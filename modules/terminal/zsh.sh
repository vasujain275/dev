#!/bin/bash
# ZSH Installation and Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing ZSH and utilities"

# Install ZSH and related utilities
log_subsection "Installing ZSH and shell utilities"
install_packages \
    wget \
    kitty \
    ghostty \
    progress \
    zsh \
    exfatprogs \
    starship \
    zoxide \
    fnm \
    eza \
    bat \
    tree \
    grep \
    ripgrep \
    fzf \
    yazi \
    zip \
    unrar \
    file-roller \
    duf

# Change default shell to ZSH
log_subsection "Setting ZSH as default shell"
current_shell=$(getent passwd $USER | cut -d: -f7)
zsh_path=$(which zsh)

if [ "$current_shell" != "$zsh_path" ]; then
    log_info "Changing default shell to ZSH"
    sudo chsh -s "$zsh_path" "$USER"
    if [ $? -eq 0 ]; then
        log_success "Default shell changed to ZSH"
    else
        log_error "Failed to change default shell to ZSH"
        exit 1
    fi
else
    log_info "ZSH is already the default shell"
fi

log_success "ZSH installation and setup completed"

# Inform the user that they may need to log out and back in
log_info "Note: You may need to log out and back in for the shell change to take effect"
