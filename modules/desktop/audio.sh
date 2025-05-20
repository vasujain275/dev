#!/bin/bash
# Audio Setup with Pipewire
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up Pipewire Audio System"

# Install Pipewire and related packages
log_subsection "Installing Pipewire and related packages"
install_packages \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber \
    qpwgraph \
    pavucontrol

# Function to enable and start a systemd user service
enable_user_service() {
    local service_name="$1"
    
    log_info "Enabling and starting $service_name"
    
    # Enable the service for the current user
    systemctl --user enable "$service_name" &>/dev/null
    if [ $? -ne 0 ]; then
        log_error "Failed to enable $service_name"
        return 1
    fi
    
    # Start the service for the current user
    systemctl --user start "$service_name" &>/dev/null
    if [ $? -ne 0 ]; then
        log_error "Failed to start $service_name"
        return 1
    fi
    
    # Verify the service is running
    if systemctl --user is-active "$service_name" &>/dev/null; then
        log_success "$service_name is enabled and running"
        return 0
    else
        log_error "$service_name failed to start properly"
        return 1
    fi
}

# Enable and start Pipewire and related services
log_subsection "Enabling and starting Pipewire services"

# Enable Pipewire socket
enable_user_service "pipewire.socket" || true

# Enable Pipewire Pulse socket
enable_user_service "pipewire-pulse.socket" || true

# Enable Wireplumber service
enable_user_service "wireplumber.service" || true

# Check overall status of audio setup
log_subsection "Verifying audio setup"

# Check if at least one of PipeWire or PulseAudio is running
if systemctl --user is-active pipewire.service &>/dev/null || \
   systemctl --user is-active pipewire-pulse.service &>/dev/null; then
    log_success "Audio system is set up and running"
else
    log_error "Audio system setup may have issues. Check the services manually."
    log_info "Run 'systemctl --user status pipewire' for more information"
fi

log_success "Audio setup completed"
log_info "You can use pavucontrol to configure audio devices and qpwgraph to manage audio routing"
