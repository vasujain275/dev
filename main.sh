#!/bin/bash

# Main setup script for Arch Linux with Hyprland
# Author: Vasu Jain

# Source configuration and utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/tools/log.sh"
source "$SCRIPT_DIR/tools/installer.sh"

# Parse arguments
SELECTED_MODULES=()
RUN_ALL=true

usage() {
    echo "Usage: $0 [options] [module_names...]"
    echo "Options:"
    echo "  -h, --help      Show this help message"
    echo "  -l, --list      List available modules"
    echo
    echo "Available modules:"
    list_modules
    exit 1
}

list_modules() {
    log_info "Available modules:"
    
    # List base modules
    log_info "  Base system:"
    echo "    base"
    
    # List desktop modules
    log_info "  Desktop environment:"
    echo "    hyprland audio bluetooth"
    
    # List development modules
    log_info "  Development:"
    echo "    dev-base docker java node rust neovim"
    
    # List terminal modules
    log_info "  Terminal:"
    echo "    zsh tmux"
    
    # List utility modules
    log_info "  Utilities:"
    echo "    fonts aur dual-boot syncthing"
    
    # List application modules
    log_info "  Applications:"
    echo "    essential-apps media-apps productivity-apps"
}

is_valid_module() {
    local module=$1
    
    # Define valid modules
    case "$module" in
        # Base
        base)
            return 0 ;;
            
        # Desktop
        hyprland|audio|bluetooth)
            return 0 ;;
            
        # Development
        dev-base|docker|java|node|rust|neovim)
            return 0 ;;
            
        # Terminal
        zsh|tmux)
            return 0 ;;
            
        # Utilities
        fonts|aur|dual-boot|syncthing)
            return 0 ;;
            
        # Applications
        essential-apps|media-apps|productivity-apps)
            return 0 ;;
            
        *)
            return 1 ;;
    esac
}

# Parse command line arguments
if [ $# -gt 0 ]; then
    RUN_ALL=false
    
    while [ $# -gt 0 ]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -l|--list)
                list_modules
                exit 0
                ;;
            *)
                if is_valid_module "$1"; then
                    SELECTED_MODULES+=("$1")
                else
                    log_error "Invalid module: $1"
                    usage
                fi
                ;;
        esac
        shift
    done
fi

# Run modules
run_module() {
    local module=$1
    local script_path=""
    
    # Map module name to script path
    case "$module" in
        # Base
        base)
            script_path="modules/base.sh" ;;
            
        # Desktop
        hyprland)
            script_path="modules/desktop/hyprland.sh" ;;
        audio)
            script_path="modules/desktop/audio.sh" ;;
        bluetooth)
            script_path="modules/desktop/bluetooth.sh" ;;
            
        # Development
        dev-base)
            script_path="modules/development/base.sh" ;;
        docker)
            script_path="modules/development/docker.sh" ;;
        java)
            script_path="modules/development/java.sh" ;;
        node)
            script_path="modules/development/node.sh" ;;
        rust)
            script_path="modules/development/rust.sh" ;;
        neovim)
            script_path="modules/development/neovim.sh" ;;
            
        # Terminal
        zsh)
            script_path="modules/terminal/zsh.sh" ;;
        tmux)
            script_path="modules/terminal/tmux.sh" ;;
            
        # Utilities
        fonts)
            script_path="modules/utilities/fonts.sh" ;;
        aur)
            script_path="modules/utilities/aur-helpers.sh" ;;
        dual-boot)
            script_path="modules/utilities/dual-boot.sh" ;;
        syncthing)
            script_path="modules/utilities/syncthing.sh" ;;
            
        # Applications
        essential-apps)
            script_path="modules/apps/essential.sh" ;;
        media-apps)
            script_path="modules/apps/media.sh" ;;
        productivity-apps)
            script_path="modules/apps/productivity.sh" ;;
    esac
    
    if [ -f "$SCRIPT_DIR/$script_path" ]; then
        log_section "Running module: $module"
        bash "$SCRIPT_DIR/$script_path"
        log_success "Module $module completed successfully"
    else
        log_error "Script for module $module not found: $SCRIPT_DIR/$script_path"
    fi
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log_error "Please do not run this script as root"
        exit 1
    fi
}

# Main function
main() {
    check_root
    
    log_section "Beginning Arch Linux setup"
    log_info "User: $(whoami)"
    log_info "System: $(uname -a)"
    
    # Update system first
    log_section "Updating system packages"
    sudo pacman -Syu --noconfirm
    
    if [ "$RUN_ALL" = true ]; then
        # Run all modules in proper order
        log_info "Running all modules in standard order"
        
        # Base module first
        run_module "base"
        
        # AUR helpers before other modules
        run_module "aur"
        
        # Terminal setup
        run_module "zsh"
        run_module "tmux"
        
        # Fonts and utilities
        run_module "fonts"
        
        # Desktop environment
        run_module "hyprland"
        run_module "audio"
        run_module "bluetooth"
        
        
        # Development tools
        run_module "dev-base"
        run_module "docker"
        run_module "node"
        run_module "java"
        run_module "rust"
        run_module "neovim"
        
        # Other utilities
        run_module "syncthing"
        run_module "dual-boot"
        
        # Applications
        run_module "essential-apps"
        run_module "media-apps"
        run_module "productivity-apps"
    else
        log_info "Running selected modules: ${SELECTED_MODULES[*]}"
        
        # Run selected modules
        for module in "${SELECTED_MODULES[@]}"; do
            run_module "$module"
        done
    fi
    
    log_success "Setup completed successfully"
}

# Execute main function
main
