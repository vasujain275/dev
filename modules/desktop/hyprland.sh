#!/bin/bash
# Hyprland Installation and Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing Hyprland and dependencies"

# Install Hyprland related packages
log_subsection "Installing Hyprland related packages"
install_packages \
    swww \
    hyprpicker \
    hyprsunset \
    hyprlock \
    hypridle \
    waypaper \
    archlinux-xdg-menu \
    grim \
    slurp

# Install utility packages
log_subsection "Installing Hyprland utilities"
install_packages \
    dunst \
    rofi-wayland \
    waybar \
    wlogout \
    hyprshot \
    brightnessctl

# Install clipboard utilities
log_subsection "Installing clipboard utilities"
install_packages \
    wl-clipboard \
    xclip \
    cliphist

# Check if Hyprland is properly installed
log_subsection "Verifying Hyprland installation"
if command -v hyprctl &> /dev/null; then
    log_success "Hyprland is installed and available"
    HYPR_VERSION=$(hyprctl version | head -n 1)
    log_info "Detected: $HYPR_VERSION"
else
    log_error "Hyprland binary not found in PATH. Installation may have failed."
    log_info "You might need to install the main 'hyprland' package if not already installed."
fi

# Create necessary directories for Hyprland config if they don't exist
log_subsection "Setting up Hyprland configuration directory"
HYPR_CONFIG_DIR="$HOME/.config/hypr"
if [ ! -d "$HYPR_CONFIG_DIR" ]; then
    log_info "Creating Hyprland configuration directory"
    mkdir -p "$HYPR_CONFIG_DIR"
    log_success "Created directory: $HYPR_CONFIG_DIR"
else
    log_info "Hyprland configuration directory already exists"
fi

log_success "Hyprland dependencies installation completed"
log_info "You may need to configure Hyprland further by editing files in $HYPR_CONFIG_DIR"
