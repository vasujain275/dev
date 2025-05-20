#!/bin/bash
# Dual Boot Configuration Script
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Configuring Dual Boot Environment"

# Install ntfs-3g and os-prober
log_subsection "Installing dual boot packages"
log_info "Installing ntfs-3g and os-prober"
if install_packages ntfs-3g os-prober; then
    log_success "ntfs-3g and os-prober installed successfully"
else
    log_error "Failed to install dual boot packages"
    exit 1
fi

# Verify package installation
log_subsection "Verifying package installation"
if pacman -Qi ntfs-3g &>/dev/null && pacman -Qi os-prober &>/dev/null; then
    log_success "Package verification successful"
else
    log_error "Package verification failed"
    exit 1
fi

# Configure GRUB settings
log_subsection "Configuring GRUB settings"
GRUB_CONFIG="/etc/default/grub"

# Check if GRUB config file exists
if [ ! -f "$GRUB_CONFIG" ]; then
    log_error "GRUB configuration file not found at $GRUB_CONFIG"
    exit 1
fi

# Uncomment GRUB_DEFAULT
log_info "Uncommenting GRUB_DEFAULT in $GRUB_CONFIG"
if sudo sed -i 's/^#\?GRUB_DEFAULT=/GRUB_DEFAULT=/' "$GRUB_CONFIG"; then
    log_success "GRUB_DEFAULT uncommented successfully"
else
    log_error "Failed to uncomment GRUB_DEFAULT"
    exit 1
fi

# Update GRUB configuration
log_subsection "Updating GRUB configuration"
log_info "Running grub-mkconfig to update GRUB"
if sudo grub-mkconfig -o /boot/grub/grub.cfg &>/dev/null; then
    log_success "GRUB configuration updated successfully"
else
    log_error "Failed to update GRUB configuration"
    exit 1
fi

# Final verification
log_subsection "Final verification"
if grep -q "^GRUB_DEFAULT=" "$GRUB_CONFIG"; then
    log_success "GRUB_DEFAULT is properly configured"
else
    log_warning "GRUB_DEFAULT may not be properly configured"
fi

log_success "Dual boot configuration completed"
log_info "ntfs-3g and os-prober are installed and GRUB has been configured."
log_info "Windows partitions should now be detected on next boot."
