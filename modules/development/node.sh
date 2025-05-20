#!/bin/bash
# Node.js Development Environment Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up Node.js Development Environment"

# Check if fnm is installed
log_subsection "Checking fnm installation"
if ! command -v fnm &>/dev/null; then
    log_error "fnm (Fast Node Manager) is not installed"
    log_info "Please install fnm first using your package manager or chaotic-aur/fnm"
    exit 1
else
    log_success "fnm is installed and available"
fi

# Install Node.js using fnm
log_subsection "Installing Node.js using fnm"
NODE_VERSION="22"
log_info "Installing Node.js v${NODE_VERSION}"

# Run fnm install
if fnm install "$NODE_VERSION" &>/dev/null; then
    log_success "Node.js v${NODE_VERSION} installed successfully"
else
    log_error "Failed to install Node.js v${NODE_VERSION}"
    exit 1
fi

# Set default Node.js version
log_subsection "Setting default Node.js version"
log_info "Setting Node.js v${NODE_VERSION} as default"

if fnm default "$NODE_VERSION" &>/dev/null; then
    log_success "Node.js v${NODE_VERSION} set as default"
else
    log_error "Failed to set Node.js v${NODE_VERSION} as default"
    exit 1
fi

# Install yarn package manager
log_subsection "Installing yarn package manager"
install_packages yarn

# Install pnpm package manager
log_subsection "Installing pnpm package manager"
install_packages pnpm

# Verify Node.js installation
log_subsection "Verifying Node.js environment"

# Load fnm in current shell
eval "$(fnm env --use-on-cd)" &>/dev/null

# Check Node.js
if command -v node &>/dev/null; then
    NODE_VERSION_INSTALLED=$(node --version)
    log_success "Node.js is installed: $NODE_VERSION_INSTALLED"
else
    log_error "Node.js verification failed"
fi

# Check npm
if command -v npm &>/dev/null; then
    NPM_VERSION=$(npm --version)
    log_success "npm is installed: v$NPM_VERSION"
else
    log_error "npm verification failed"
fi

# Check yarn
if command -v yarn &>/dev/null; then
    YARN_VERSION=$(yarn --version)
    log_success "yarn is installed: v$YARN_VERSION"
else
    log_error "yarn verification failed"
fi

# Check pnpm
if command -v pnpm &>/dev/null; then
    PNPM_VERSION=$(pnpm --version)
    log_success "pnpm is installed: v$PNPM_VERSION"
else
    log_error "pnpm verification failed"
fi

log_success "Node.js development environment setup completed"
log_info "To use Node.js in your current terminal, run: eval \"\$(fnm env --use-on-cd)\""
log_info "Add this to your shell profile for permanent configuration"
