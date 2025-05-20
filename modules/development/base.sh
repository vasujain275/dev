#!/bin/bash
# Development Dependencies Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing Development Dependencies"

# Install essential Dev Dependencies from official repositories and Chaotic AUR
log_subsection "Installing essential dev dependencies"
install_packages \
    stow \
    nodejs \
    lazygit \
    lazydocker \
    chaotic-aur/android-studio

# Function to install packages with yay
install_with_yay() {
    local packages=("$@")
    
    # Check if yay is installed
    if ! command -v yay &>/dev/null; then
        log_error "yay is not installed. Cannot install AUR packages."
        log_info "Please install yay first using your aur-helpers.sh script"
        return 1
    fi
    
    log_info "Installing AUR packages with yay: ${packages[*]}"
    
    # Use yay to install packages
    yay -S --noconfirm "${packages[@]}"
    
    if [ $? -eq 0 ]; then
        log_success "AUR packages installed successfully"
        return 0
    else
        log_error "Failed to install some AUR packages"
        return 1
    fi
}

# Install AUR Development Dependencies with yay
log_subsection "Installing AUR dev dependencies"
install_with_yay \
    intellij-idea-ultimate-edition \
    bruno-bin \
    localsend-bin

# Verify installations
log_subsection "Verifying installations"

# Function to check if a package is installed
check_package() {
    local package=$1
    local display_name=$2
    
    if pacman -Q "$package" &>/dev/null; then
        log_success "$display_name is installed"
    else
        log_error "$display_name does not appear to be installed"
    fi
}

# Check essential packages
check_package "stow" "GNU Stow"
check_package "nodejs" "Node.js"
check_package "lazygit" "LazyGit"
check_package "lazydocker" "LazyDocker"

# Check AUR packages - note that package names might be slightly different in the database
check_package "intellij-idea-ultimate-edition" "IntelliJ IDEA Ultimate"
check_package "bruno-bin" "Bruno API Client"
check_package "localsend-bin" "LocalSend"

# Check Android Studio - name might vary
if pacman -Q "android-studio" &>/dev/null; then
    log_success "Android Studio is installed"
else
    log_error "Android Studio does not appear to be installed"
fi

log_success "Development dependencies setup completed"
log_info "You may need to log out and back in for some changes to take effect"
