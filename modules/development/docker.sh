#!/bin/bash
# Docker Installation Script
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Installing Docker"

# Install Docker and related packages
log_subsection "Installing Docker packages"
install_packages \
    docker \
    docker-compose \
    docker-buildx

# Enable Docker service
log_subsection "Enabling Docker service"
log_info "Enabling docker.service"
if sudo systemctl enable docker.service &>/dev/null; then
    log_success "Docker service enabled successfully"
else
    log_error "Failed to enable Docker service"
    exit 1
fi

# Start Docker service
log_info "Starting docker.service"
if sudo systemctl start docker.service &>/dev/null; then
    log_success "Docker service started successfully"
else
    log_error "Failed to start Docker service"
    exit 1
fi

# Add current user to docker group
log_subsection "Setting up Docker permissions"
CURRENT_USER=$(whoami)
log_info "Adding user '$CURRENT_USER' to docker group"
if sudo usermod -aG docker "$CURRENT_USER" &>/dev/null; then
    log_success "User added to docker group successfully"
else
    log_error "Failed to add user to docker group"
    exit 1
fi

# Verify Docker installation
log_subsection "Verifying Docker installation"
if command -v docker &>/dev/null && docker --version &>/dev/null; then
    DOCKER_VERSION=$(docker --version)
    log_success "Docker installed successfully: $DOCKER_VERSION"
    
    # Check Docker Compose
    if command -v docker-compose &>/dev/null; then
        COMPOSE_VERSION=$(docker-compose --version)
        log_success "Docker Compose installed: $COMPOSE_VERSION"
    else
        log_error "Docker Compose not found in PATH"
    fi
else
    log_error "Docker installation verification failed"
fi

log_success "Docker installation completed"
log_info "Docker has been installed and configured. The user $CURRENT_USER has been added to the docker group."
log_info "You may need to log out and back in for group changes to take effect."
