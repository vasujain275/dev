#!/bin/bash
# Bluetooth Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up Bluetooth"

# Install Bluetooth packages
log_subsection "Installing Bluetooth packages"
install_packages \
    bluez \
    blueman \
    bluez-utils

# Enable and start Bluetooth service
log_subsection "Enabling Bluetooth service"
log_info "Enabling and starting bluetooth.service"

if sudo systemctl enable bluetooth &>/dev/null; then
    log_info "Bluetooth service enabled successfully"
else
    log_error "Failed to enable Bluetooth service"
    exit 1
fi

if sudo systemctl start bluetooth &>/dev/null; then
    log_success "Bluetooth service started successfully"
else
    log_error "Failed to start Bluetooth service"
    exit 1
fi

# Verify Bluetooth service status
log_subsection "Verifying Bluetooth setup"
if sudo systemctl is-active bluetooth &>/dev/null; then
    log_success "Bluetooth service is active and running"
    
    # Check if Bluetooth adapter is available
    if command -v bluetoothctl &>/dev/null; then
        ADAPTER_INFO=$(bluetoothctl list 2>/dev/null)
        if [ -n "$ADAPTER_INFO" ]; then
            log_info "Bluetooth adapter found:"
            echo "$ADAPTER_INFO" | sed 's/^/    /'
        else
            log_info "No Bluetooth adapters found. Hardware may be disabled or missing."
            log_info "Try running 'bluetoothctl list' to check for adapters"
        fi
    fi
else
    log_error "Bluetooth service is not running properly"
    log_info "Run 'sudo systemctl status bluetooth' for more information"
fi

log_success "Bluetooth setup completed"
log_info "You can use blueman-applet for a graphical Bluetooth manager"
log_info "Or use bluetoothctl from the terminal to manage Bluetooth devices"
