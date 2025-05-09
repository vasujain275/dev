#!/bin/bash
# Font Installation Script
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing Fonts"

# Install Fira Sans, Font Awesome, Roboto, and DejaVu fonts
log_subsection "Installing basic fonts"
install_packages \
    ttf-fira-sans \
    ttf-font-awesome \
    ttf-roboto \
    ttf-dejavu

# Install JetBrains Mono Nerd Font
log_subsection "Installing JetBrains Mono Nerd Font"
install_packages ttf-jetbrains-mono-nerd

# Install Noto fonts
log_subsection "Installing Noto fonts"
install_packages \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts-extra

# Install Space Mono Nerd Font and Nerd Fonts Symbols
log_subsection "Installing Space Mono and Nerd Fonts Symbols"
install_packages \
    ttf-space-mono-nerd \
    ttf-nerd-fonts-symbols

# Refresh font cache
log_subsection "Refreshing font cache"
if command -v fc-cache &> /dev/null; then
    log_info "Running fc-cache -fv"
    fc-cache -fv
    if [ $? -eq 0 ]; then
        log_success "Font cache refreshed successfully"
    else
        log_error "Failed to refresh font cache"
    fi
else
    log_info "fc-cache not found, skipping font cache refresh"
fi

log_success "Font installation completed"
log_info "New fonts are now available for system and applications"
