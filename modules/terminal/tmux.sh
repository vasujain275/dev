#!/bin/bash
# Tmux Installation and Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up Tmux"

# Install Tmux
log_subsection "Installing Tmux"
install_packages tmux

# Set up Tmux Plugin Manager (TPM)
log_subsection "Setting up Tmux Plugin Manager"

# Create directory if it doesn't exist
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    log_info "Creating directory for TPM"
    mkdir -p "$HOME/.tmux/plugins"
fi

# Clone TPM if not already present
if [ ! -d "$TPM_DIR/.git" ]; then
    log_info "Cloning Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    
    if [ $? -eq 0 ]; then
        log_success "TPM installed successfully"
    else
        log_error "Failed to clone TPM repository"
        exit 1
    fi
else
    log_info "TPM is already installed, updating..."
    cd "$TPM_DIR" && git pull
    log_success "TPM updated successfully"
fi

log_success "Tmux setup completed"

# Provide helpful information about TPM usage
log_info "To install plugins with TPM, add plugin entries to ~/.tmux.conf"
log_info "Example: set -g @plugin 'tmux-plugins/tmux-sensible'"
log_info "Then press prefix + I (capital I) to install plugins"
