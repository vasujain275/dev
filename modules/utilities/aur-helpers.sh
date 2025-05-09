#!/bin/bash

# AUR helpers installation
# Author: Vasu Jain

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up AUR helpers"

# Install Yay
install_yay() {
    log_subsection "Installing Yay AUR helper"
    
    if has_command yay; then
        log_success "Yay is already installed"
        return 0
    fi
    
    # Install dependencies
    install_packages git base-devel
    
    # Create temp directory
    local temp_dir=$(mktemp -d)
    log_info "Cloning yay to $temp_dir"
    
    # Clone and build yay
    git clone https://aur.archlinux.org/yay.git "$temp_dir/yay"
    cd "$temp_dir/yay" || exit 1
    makepkg -si --noconfirm
    
    # Clean up
    cd "$OLDPWD" || exit 1
    rm -rf "$temp_dir"
    
    if has_command yay; then
        log_success "Yay installed successfully"
    else
        log_error "Failed to install Yay"
        return 1
    fi
}

# Set up Chaotic AUR if enabled
setup_chaotic_aur() {
    if [ "$ENABLE_CHAOTIC_AUR" != true ]; then
        log_info "Chaotic AUR is disabled in config"
        return 0
    fi
    
    log_subsection "Setting up Chaotic AUR"
    
    # Check if Chaotic AUR is already set up
    if grep -q "chaotic-aur" /etc/pacman.conf; then
        log_success "Chaotic AUR is already set up"
        return 0
    fi
    
    # Get and sign the key
    log_info "Receiving Chaotic AUR key"
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    
    # Install keyring and mirrorlist
    log_info "Installing Chaotic AUR keyring and mirrorlist"
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    
    # Add to pacman.conf
    log_info "Adding Chaotic AUR to pacman.conf"
    sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
    
    sudo pacman -Syu --noconfirm
    
    log_success "Chaotic AUR set up successfully"
}

# Install Yay
install_yay

# Set up Chaotic AUR if enabled
setup_chaotic_aur

log_success "AUR helpers setup completed"
