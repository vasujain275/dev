#!/bin/bash
# Java Development Environment Setup
# Author: Vasu Jain

# Define correct script directory and source paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../tools/log.sh"
source "$SCRIPT_DIR/../../tools/installer.sh"
source "$SCRIPT_DIR/../../config.sh"

log_section "Setting up Java Development Environment"

# Install Java development tools
log_subsection "Installing Java development tools"
install_packages \
    maven \
    gradle

# Install dependencies for SDKMAN
log_subsection "Installing SDKMAN dependencies"
install_packages \
    unzip \
    zip \
    curl \
    git

# Download and install SDKMAN
log_subsection "Installing SDKMAN"
USER_HOME="$HOME"
SDKMAN_DIR="$USER_HOME/.sdkman"

# Check if SDKMAN is already installed
if [ -d "$SDKMAN_DIR" ] && [ -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
    log_info "SDKMAN is already installed"
else
    log_info "Downloading SDKMAN installation script"
    curl -s "https://get.sdkman.io" -o /tmp/sdkman_install.sh
    
    if [ $? -ne 0 ]; then
        log_error "Failed to download SDKMAN installation script"
        exit 1
    fi
    
    log_info "Installing SDKMAN"
    chmod +x /tmp/sdkman_install.sh
    bash /tmp/sdkman_install.sh
    
    if [ $? -ne 0 ]; then
        log_error "SDKMAN installation failed"
        exit 1
    else
        log_success "SDKMAN installed successfully"
    fi
    
    # Clean up installation script
    rm -f /tmp/sdkman_install.sh
fi

# Source SDKMAN for the current session
source "$SDKMAN_DIR/bin/sdkman-init.sh" || {
    log_error "Failed to source SDKMAN environment"
    exit 1
}

# Install Java using SDKMAN
log_subsection "Installing Java 23.0.2-tem"
JAVA_VERSION="23.0.2-tem"

# Check if this Java version is already installed
if [ -d "$SDKMAN_DIR/candidates/java/$JAVA_VERSION" ]; then
    log_info "Java $JAVA_VERSION is already installed"
else
    log_info "Installing Java $JAVA_VERSION"
    sdk install java "$JAVA_VERSION" < /dev/null
    
    if [ $? -ne 0 ]; then
        log_error "Failed to install Java $JAVA_VERSION"
        exit 1
    else
        log_success "Java $JAVA_VERSION installed successfully"
    fi
fi

# Set Java version as default
log_subsection "Setting Java $JAVA_VERSION as default"
log_info "Setting Java $JAVA_VERSION as default"
sdk default java "$JAVA_VERSION"

if [ $? -ne 0 ]; then
    log_error "Failed to set Java $JAVA_VERSION as default"
    exit 1
else
    log_success "Java $JAVA_VERSION set as default"
fi

# Verify Java installation
log_subsection "Verifying Java development environment"

# Check Java
if command -v java &>/dev/null; then
    JAVA_VERSION_INSTALLED=$(java -version 2>&1 | head -n 1)
    log_success "Java is installed: $JAVA_VERSION_INSTALLED"
else
    log_error "Java verification failed"
fi

# Check Maven
if command -v mvn &>/dev/null; then
    MVN_VERSION=$(mvn --version | head -n 1)
    log_success "Maven is installed: $MVN_VERSION"
else
    log_error "Maven verification failed"
fi

# Check Gradle
if command -v gradle &>/dev/null; then
    GRADLE_VERSION=$(gradle --version | head -n 1)
    log_success "Gradle is installed: $GRADLE_VERSION"
else
    log_error "Gradle verification failed"
fi

log_success "Java development environment setup completed"
log_info "Java development environment has been set up with Maven, Gradle, and SDKMAN."
log_info "Java $JAVA_VERSION has been installed and set as default."
log_info "To use SDKMAN in a new session, run: source $SDKMAN_DIR/bin/sdkman-init.sh"
log_info "Consider adding this to your shell profile for permanent configuration"
