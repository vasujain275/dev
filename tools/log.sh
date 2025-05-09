#!/bin/bash

# Logging utility functions for Arch Linux setup
# Author: Vasu Jain

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_section() {
    echo -e "\n${BOLD}${MAGENTA}==>${NC} ${BOLD}$1${NC}"
    echo -e "${MAGENTA}$(printf '=%.0s' {1..50})${NC}"
}

log_subsection() {
    echo -e "\n${BOLD}${CYAN}-->${NC} ${BOLD}$1${NC}"
}

# Ask for confirmation
confirm() {
    local prompt="$1"
    local default="${2:-Y}"
    
    if [ "$default" = "Y" ]; then
        options="[Y/n]"
    else
        options="[y/N]"
    fi
    
    read -p "$(echo -e "${YELLOW}${prompt} ${options}:${NC} ")" response
    
    if [ -z "$response" ]; then
        response="$default"
    fi
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        return 0
    else
        return 1
    fi
}

# Create a log file
setup_logging() {
    local log_dir="${1:-$HOME/.logs/arch-setup}"
    local log_file="$log_dir/setup-$(date +%Y%m%d-%H%M%S).log"
    
    mkdir -p "$log_dir"
    
    # Redirect output to log file while still displaying it
    exec > >(tee -a "$log_file")
    exec 2>&1
    
    log_info "Log file created at $log_file"
}
