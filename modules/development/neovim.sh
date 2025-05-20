#!/bin/bash
# Neovim and dependencies installation
# Follows the structure of base.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../tools/log.sh"
source "$SCRIPT_DIR/../tools/installer.sh"
source "$SCRIPT_DIR/../config.sh"

log_section "Installing Neovim and dependencies"

log_subsection "Installing Neovim and unzip"
install_packages \
  neovim \
  unzip

log_success "Neovim and unzip installation completed"
