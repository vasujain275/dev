#!/bin/bash

# Base system setup
# Author: Vasu Jain

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../tools/log.sh"
source "$SCRIPT_DIR/../tools/installer.sh"
source "$SCRIPT_DIR/../config.sh"

log_section "Installing base system packages"

# Base system utilities
log_subsection "Installing essential system utilities"
install_packages \
    base-devel \
    curl \
    wget \
    git \
    stow \
    grep \
    ripgrep \
    tree \
    htop \
    btop \
    neofetch \
    fastfetch \
    lm_sensors \
    inxi \
    pciutils \
    usbutils \
    ncdu \
    bc \
    libnotify \
    unzip \
    zip \
    p7zip \
    unrar \
    file-roller \
    socat \
    lshw

# Hardware information and monitoring tools
log_subsection "Installing hardware monitoring tools"
install_packages \
    nvtop \
    ydotool

# Network tools
log_subsection "Installing network utilities"
install_packages \
    tailscale

if confirm "Enable and start Tailscale service?" "Y"; then
    enable_service "tailscaled"
    execute_command "sudo tailscale up" "Failed to set up Tailscale"
fi

# Power management
log_subsection "Installing power management tools"
install_packages \
    auto-cpufreq

enable_service "auto-cpufreq"

# Increase pacman parallel downloads
log_subsection "Configuring pacman"
if [ "$PACMAN_PARALLEL_DOWNLOADS" -gt 1 ]; then
    log_info "Setting parallel downloads to $PACMAN_PARALLEL_DOWNLOADS"
    sudo sed -i "s/#ParallelDownloads = [0-9]*/ParallelDownloads = $PACMAN_PARALLEL_DOWNLOADS/" /etc/pacman.conf
fi

# Enable multilib if configured
if [ "$ENABLE_MULTILIB" = true ]; then
    log_info "Enabling multilib repository"
    sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
    sudo pacman -Syu --noconfirm
fi

log_success "Base system setup completed"
