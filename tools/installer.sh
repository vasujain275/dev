#!/bin/bash

# Package installation helper functions
# Author: Vasu Jain

# Source logging functions if not already available
if ! command -v log_info &> /dev/null; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/log.sh"
fi

# Source config if not already available
if [ -z "$USER_NAME" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../config.sh"
fi

# Check if a command exists
has_command() {
    command -v "$1" &> /dev/null
}

# Check if a package is installed
is_installed() {
    pacman -Q "$1" &> /dev/null
}

# Install packages using pacman
install_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_warn "No packages specified for installation"
        return 0
    fi
    
    log_info "Installing packages: ${packages[*]}"
    
    # Filter out already installed packages
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log_info "Package $pkg is already installed, skipping"
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_success "All packages are already installed"
        return 0
    fi
    
    sudo pacman -S $PACMAN_OPTIONS "${to_install[@]}"
    
    # Check if installation was successful
    for pkg in "${to_install[@]}"; do
        if is_installed "$pkg"; then
            log_success "Package $pkg installed successfully"
        else
            log_error "Failed to install package $pkg"
            return 1
        fi
    done
    
    return 0
}

# Install packages from AUR using yay
install_aur_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_warn "No AUR packages specified for installation"
        return 0
    fi
    
    # Check if yay is installed
    if ! has_command yay; then
        log_error "yay is not installed. Please run the AUR helpers module first"
        return 1
    fi
    
    log_info "Installing AUR packages: ${packages[*]}"
    
    # Filter out already installed packages
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        else
            log_info "Package $pkg is already installed, skipping"
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_success "All AUR packages are already installed"
        return 0
    fi
    
    yay -S $YAY_OPTIONS "${to_install[@]}"
    
    # Check if installation was successful
    for pkg in "${to_install[@]}"; do
        if is_installed "$pkg"; then
            log_success "Package $pkg installed successfully"
        else
            log_error "Failed to install package $pkg"
            return 1
        fi
    done
    
    return 0
}

# Enable and start a systemd service
enable_service() {
    local service=$1
    local user=${2:-false}  # Default to system service
    
    log_info "Enabling service: $service"
    
    if [ "$user" = true ]; then
        # User service
        if systemctl --user is-enabled "$service" &> /dev/null; then
            log_info "Service $service is already enabled"
        else
            systemctl --user enable "$service"
            log_success "Service $service enabled"
        fi
        
        if systemctl --user is-active "$service" &> /dev/null; then
            log_info "Service $service is already running"
        else
            systemctl --user start "$service"
            log_success "Service $service started"
        fi
    else
        # System service
        if systemctl is-enabled "$service" &> /dev/null; then
            log_info "Service $service is already enabled"
        else
            sudo systemctl enable "$service"
            log_success "Service $service enabled"
        fi
        
        if systemctl is-active "$service" &> /dev/null; then
            log_info "Service $service is already running"
        else
            sudo systemctl start "$service"
            log_success "Service $service started"
        fi
    fi
}

# Create a directory if it doesn't exist
ensure_dir() {
    local dir=$1
    local mode=${2:-755}
    
    if [ ! -d "$dir" ]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
        chmod "$mode" "$dir"
    fi
}

# Clone or update a Git repository
clone_or_update_repo() {
    local repo_url=$1
    local dest_dir=$2
    
    if [ -d "$dest_dir/.git" ]; then
        log_info "Updating repository: $repo_url"
        git -C "$dest_dir" pull
    else
        log_info "Cloning repository: $repo_url"
        git clone "$repo_url" "$dest_dir"
    fi
}

# Add a line to a file if it doesn't exist
add_line_to_file() {
    local line=$1
    local file=$2
    local sudo=${3:-false}  # Default to non-sudo
    
    if [ ! -f "$file" ]; then
        if [ "$sudo" = true ]; then
            sudo touch "$file"
        else
            touch "$file"
        fi
    fi
    
    if ! grep -qF "$line" "$file"; then
        log_info "Adding line to $file"
        if [ "$sudo" = true ]; then
            echo "$line" | sudo tee -a "$file" > /dev/null
        else
            echo "$line" >> "$file"
        fi
    fi
}

# Replace a line in a file
replace_line_in_file() {
    local pattern=$1
    local replacement=$2
    local file=$3
    local sudo=${4:-false}  # Default to non-sudo
    
    if [ ! -f "$file" ]; then
        log_error "File $file does not exist"
        return 1
    fi
    
    if [ "$sudo" = true ]; then
        sudo sed -i "s|$pattern|$replacement|g" "$file"
    else
        sed -i "s|$pattern|$replacement|g" "$file"
    fi
}

# Execute a command with error handling
execute_command() {
    local cmd=$1
    local error_msg=${2:-"Command failed"}
    
    log_info "Executing: $cmd"
    
    if eval "$cmd"; then
        return 0
    else
        log_error "$error_msg"
        return 1
    fi
}

# Execute a command as a different user
execute_as_user() {
    local user=$1
    local cmd=$2
    
    log_info "Executing as user $user: $cmd"
    
    if [ "$(whoami)" = "$user" ]; then
        # Already running as the target user
        eval "$cmd"
    else
        # Running as different user, use sudo
        sudo -u "$user" bash -c "$cmd"
    fi
}
