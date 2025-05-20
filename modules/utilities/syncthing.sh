#!/bin/bash
# Syncthing Installation Script
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing and configuring Syncthing"

# Install Syncthing
log_subsection "Installing Syncthing package"
log_info "Installing syncthing"
if install_packages syncthing; then
    log_success "Syncthing installed successfully"
else
    log_error "Failed to install Syncthing"
    exit 1
fi

# Enable Syncthing service
log_subsection "Enabling Syncthing service"
CURRENT_USER=$(whoami)
log_info "Enabling syncthing@$CURRENT_USER.service"
if sudo systemctl enable "syncthing@$CURRENT_USER.service" &>/dev/null; then
    log_success "Syncthing service enabled successfully"
else
    log_error "Failed to enable Syncthing service"
    exit 1
fi

# Start Syncthing service
log_info "Starting syncthing@$CURRENT_USER.service"
if sudo systemctl start "syncthing@$CURRENT_USER.service" &>/dev/null; then
    log_success "Syncthing service started successfully"
else
    log_error "Failed to start Syncthing service"
    exit 1
fi

# Verify Syncthing installation
log_subsection "Verifying Syncthing installation"
if command -v syncthing &>/dev/null && syncthing --version &>/dev/null; then
    SYNCTHING_VERSION=$(syncthing --version | head -n 1)
    log_success "Syncthing installed successfully: $SYNCTHING_VERSION"
    
    # Check service status
    if systemctl is-active --quiet "syncthing@$CURRENT_USER.service"; then
        log_success "Syncthing service is running"
    else
        log_warning "Syncthing service is not running"
    fi
else
    log_error "Syncthing installation verification failed"
fi

log_success "Syncthing installation completed"
log_info "Syncthing has been installed and configured for user $CURRENT_USER."
log_info "Access the web interface at http://localhost:8384/ after service starts."
