# Arch Linux Hyprland Setup Scripts

A modular bash script system for automating the setup of Arch Linux with Hyprland.

## Overview

This repository contains scripts to automate the installation and configuration of Arch Linux with Hyprland desktop environment. The scripts are organized modularly, allowing you to install specific components as needed.

## Requirements

- A fresh or existing Arch Linux installation
- sudo privileges
- Basic bash knowledge for customization

## Usage

### Basic Usage

To run the complete setup:

```bash
chmod +x main.sh
./main.sh
```

### Installing Specific Modules

To install specific modules:

```bash
./main.sh module1 module2 module3
```

For example, to install just the ZSH shell and Neovim:

```bash
./main.sh zsh neovim
```

### Available Modules

Run the following command to see all available modules:

```bash
./main.sh -l
```

## Module Categories

- **Base System**: Core system utilities
- **Desktop Environment**: Hyprland, audio, and bluetooth
- **Browsers**: Brave and Firefox
- **Development**: Docker, Java, Node.js, Rust, Neovim, etc.
- **Terminal**: ZSH and Tmux
- **Utilities**: Fonts, AUR helpers, dual-boot configuration, etc.
- **Applications**: Essential, media, and productivity applications

## Customization

To customize the installation, edit the `config.sh` file to set your preferences.

## Directory Structure

```
arch-setup/
├── main.sh                 # Main script
├── config.sh                # Configuration variables
├── README.md                # Documentation
├── modules/                 # Individual module scripts
│   ├── base.sh              # Base system utilities
│   ├── desktop/
│   │   ├── hyprland.sh      # Hyprland and related utilities
│   │   ├── audio.sh         # Audio configuration
│   │   └── bluetooth.sh     # Bluetooth configuration
│   ├── browsers/
│   │   ├── brave.sh         # Brave browser
│   │   └── firefox.sh       # Firefox browser
│   ├── development/
│   │   ├── base.sh          # Common development tools
│   │   ├── docker.sh        # Docker setup
│   │   ├── java.sh          # Java development
│   │   ├── node.sh          # Node.js development
│   │   ├── rust.sh          # Rust development
│   │   └── neovim.sh        # Neovim setup
│   ├── terminal/
│   │   ├── zsh.sh           # ZSH shell setup
│   │   └── tmux.sh          # Tmux terminal multiplexer
│   ├── utilities/
│   │   ├── fonts.sh         # Font installation
│   │   ├── aur-helpers.sh   # AUR helpers (yay, etc.)
│   │   ├── dual-boot.sh     # Dual boot configuration
│   │   └── syncthing.sh     # Syncthing setup
│   └── apps/
│       ├── essential.sh     # Essential applications
│       ├── media.sh         # Media applications
│       └── productivity.sh  # Productivity applications
└── tools/                   # Utility scripts
    ├── installer.sh         # Package installation helper
    └── log.sh               # Logging functions
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
