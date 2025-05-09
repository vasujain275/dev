#!/bin/bash

# Configuration variables for Arch Linux setup
# Author: Vasu Jain

# User settings
USER_NAME="$(whoami)"
USER_HOME="$HOME"

# System settings
ENABLE_AUR=true
ENABLE_CHAOTIC_AUR=false  # Set to true to enable Chaotic AUR
ENABLE_MULTILIB=true
TIMEZONE="Asia/Kolkata"            # Set to your timezone if needed
LOCALE="en_US.UTF-8"

# Desktop environment settings
DESKTOP_ENV="hyprland"
ENABLE_BLUETOOTH=true
ENABLE_AUDIO=true

# Development settings
DEV_EDITORS=("neovim")
ENABLE_DOCKER=true
ENABLE_JAVA=true
JAVA_VERSION="23.0.2-tem"
ENABLE_NODE=true
NODE_VERSION="22"
ENABLE_RUST=true

# Browser settings
DEFAULT_BROWSER="brave"  # Options: brave, firefox, google-chrome

# Syncthing settings
ENABLE_SYNCTHING=true

# Dual boot settings
DUAL_BOOT=true

# Package manager settings
PACMAN_PARALLEL_DOWNLOADS=5
YAY_OPTIONS="--needed --noconfirm"
PACMAN_OPTIONS="--needed --noconfirm"
