#!/usr/bin/env bash

# 🚀 Picovis CLI Universal Installation Script
#
# This script automatically detects your operating system and architecture,
# downloads the appropriate Picovis CLI binary from GitHub releases, and
# installs it to your system.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.3
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=/opt/picovis
#
# Options:
#   --version=VERSION    Install specific version (default: latest)
#   --prefix=PREFIX      Install to custom directory (default: /usr/local)
#   --force              Force reinstallation
#   --help               Show this help message
#
# Copyright (c) 2024 Picovis. All rights reserved.
# This software is proprietary and confidential.

set -euo pipefail

# 🎨 Colors and formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color
readonly BOLD='\033[1m'

# 📦 Configuration
readonly GITHUB_REPO="picovis/picovis-community"
readonly BINARY_NAME="picovis"
readonly INSTALL_DIR_DEFAULT="/usr/local"
readonly TEMP_DIR="/tmp/picovis-install-$$"

# 🌍 Global variables
INSTALL_VERSION="latest"
INSTALL_PREFIX="$INSTALL_DIR_DEFAULT"
FORCE_INSTALL=false
DETECTED_OS=""
DETECTED_ARCH=""
BINARY_FILENAME=""
DOWNLOAD_URL=""

# 🎯 Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  ${1}${NC}" >&2
}

log_success() {
    echo -e "${GREEN}✅ ${1}${NC}" >&2
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${1}${NC}" >&2
}

log_error() {
    echo -e "${RED}❌ ${1}${NC}" >&2
}

log_progress() {
    echo -e "${PURPLE}🔄 ${1}${NC}" >&2
}

log_header() {
    echo -e "${CYAN}${BOLD}🚀 $1${NC}" >&2
}

# 🆘 Help function
show_help() {
    cat <<EOF
${BOLD}Picovis CLI Installation Script${NC}

${BOLD}USAGE:${NC}
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- [OPTIONS]

${BOLD}OPTIONS:${NC}
    --version=VERSION    Install specific version (e.g., --version=v1.2.3)
                        Default: latest

    --prefix=PREFIX      Install to custom directory (e.g., --prefix=/opt/picovis)
                        Default: /usr/local
                        Binary will be installed to PREFIX/bin/picovis

    --force              Force reinstallation even if already installed

    --help               Show this help message

${BOLD}EXAMPLES:${NC}
    # Install latest version to /usr/local/bin
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash

    # Install specific version
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.3

    # Install to custom directory
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=\$HOME/.local

${BOLD}SUPPORTED PLATFORMS:${NC}
    • Linux x64
    • macOS x64 (Intel)
    • macOS ARM64 (Apple Silicon)

For more information, visit: https://github.com/picovis/picovis-community
EOF
}

# 🔍 Platform detection
detect_platform() {
    log_progress "Detecting platform and architecture..."

    # Detect OS
    case "$(uname -s)" in
    Linux*)
        DETECTED_OS="linux"
        ;;
    Darwin*)
        DETECTED_OS="macos"
        ;;
    *)
        log_error "Unsupported operating system: $(uname -s)"
        log_info "Supported platforms: Linux, macOS"
        exit 1
        ;;
    esac

    # Detect architecture
    case "$(uname -m)" in
    x86_64 | amd64)
        DETECTED_ARCH="x64"
        ;;
    arm64 | aarch64)
        if [[ "$DETECTED_OS" == "macos" ]]; then
            DETECTED_ARCH="arm64"
        else
            log_error "ARM64 architecture is only supported on macOS"
            log_info "For Linux, please use x64 architecture"
            exit 1
        fi
        ;;
    *)
        log_error "Unsupported architecture: $(uname -m)"
        log_info "Supported architectures: x86_64 (x64), arm64 (macOS only)"
        exit 1
        ;;
    esac

    # Note: Binary filename will be set in get_download_url() after version is determined
    log_success "Detected platform: ${DETECTED_OS}-${DETECTED_ARCH}"
}

# 🔗 Get download URL
get_download_url() {
    log_progress "Resolving download URL..."

    if [[ "$INSTALL_VERSION" == "latest" ]]; then
        log_info "Fetching latest release information..."
        local latest_release
        latest_release=$(curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

        if [[ -z "$latest_release" ]]; then
            log_error "Failed to fetch latest release information"
            log_info "Please specify a version manually with --version=vX.Y.Z"
            exit 1
        fi

        INSTALL_VERSION="$latest_release"
        log_success "Latest version: $INSTALL_VERSION"
    fi

    # Construct binary filename with version suffix to match actual asset names
    BINARY_FILENAME="picovis-${DETECTED_OS}-${DETECTED_ARCH}-${INSTALL_VERSION}"
    DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${INSTALL_VERSION}/${BINARY_FILENAME}"
    log_success "Download URL: $DOWNLOAD_URL"
}

# 📥 Download binary
download_binary() {
    log_progress "Downloading Picovis CLI binary..."

    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    local temp_binary="$TEMP_DIR/$BINARY_FILENAME"

    # Download with progress
    if command -v curl >/dev/null 2>&1; then
        if ! curl -fL --progress-bar "$DOWNLOAD_URL" -o "$temp_binary"; then
            log_error "Failed to download binary from $DOWNLOAD_URL"
            log_info "Please check if the version exists and try again"
            exit 1
        fi
    else
        log_error "curl is required but not installed"
        log_info "Please install curl and try again"
        exit 1
    fi

    # Verify download
    if [[ ! -f "$temp_binary" ]] || [[ ! -s "$temp_binary" ]]; then
        log_error "Downloaded binary is empty or missing"
        exit 1
    fi

    # Make executable
    chmod +x "$temp_binary"

    log_success "Binary downloaded successfully"
    echo "$temp_binary"
}

# 🔧 Install binary
install_binary() {
    local temp_binary="$1"
    local install_dir="$INSTALL_PREFIX/bin"
    local install_path="$install_dir/$BINARY_NAME"

    log_progress "Installing Picovis CLI to $install_path..."

    # Create install directory if it doesn't exist
    if [[ ! -d "$install_dir" ]]; then
        log_info "Creating directory: $install_dir"
        if ! mkdir -p "$install_dir" 2>/dev/null; then
            log_warning "Permission denied. Trying with sudo..."
            if ! sudo mkdir -p "$install_dir"; then
                log_error "Failed to create install directory: $install_dir"
                exit 1
            fi
        fi
    fi

    # Check if already installed and not forcing
    if [[ -f "$install_path" ]] && [[ "$FORCE_INSTALL" == false ]]; then
        local current_version
        current_version=$("$install_path" --version 2>/dev/null | head -n1 || echo "unknown")
        log_warning "Picovis CLI is already installed: $current_version"
        log_info "Use --force to reinstall or uninstall first"

        # Ask user if they want to continue
        echo -n "Do you want to continue with installation? [y/N]: " >&2
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi

    # Install binary
    if ! cp "$temp_binary" "$install_path" 2>/dev/null; then
        log_warning "Permission denied. Trying with sudo..."
        if ! sudo cp "$temp_binary" "$install_path"; then
            log_error "Failed to install binary to $install_path"
            exit 1
        fi

        # Ensure correct permissions
        sudo chmod 755 "$install_path"
        sudo chown root:root "$install_path" 2>/dev/null || true
    else
        chmod 755 "$install_path"
    fi

    log_success "Picovis CLI installed to $install_path"
}

# ✅ Verify installation
verify_installation() {
    local install_path="$INSTALL_PREFIX/bin/$BINARY_NAME"

    log_progress "Verifying installation..."

    # Check if binary exists and is executable
    if [[ ! -f "$install_path" ]]; then
        log_error "Binary not found at $install_path"
        exit 1
    fi

    if [[ ! -x "$install_path" ]]; then
        log_error "Binary is not executable: $install_path"
        exit 1
    fi

    # Test binary execution
    local version_output
    if ! version_output=$("$install_path" --version 2>&1); then
        log_error "Binary execution failed"
        log_info "Output: $version_output"
        exit 1
    fi

    log_success "Installation verified successfully"
    log_info "Version: $version_output"
}

# 🛣️ Check PATH
check_path() {
    local install_dir="$INSTALL_PREFIX/bin"

    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        log_warning "Install directory is not in your PATH: $install_dir"
        log_info "Add the following line to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo -e "${WHITE}export PATH=\"$install_dir:\$PATH\"${NC}" >&2
        log_info "Then restart your terminal or run: source ~/.bashrc"
    else
        log_success "Install directory is already in your PATH"
    fi
}

# 🧹 Cleanup
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

# 🎯 Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        --version=*)
            INSTALL_VERSION="${1#*=}"
            shift
            ;;
        --prefix=*)
            INSTALL_PREFIX="${1#*=}"
            shift
            ;;
        --force)
            FORCE_INSTALL=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            log_info "Use --help for usage information"
            exit 1
            ;;
        esac
    done
}

# 🚀 Main installation function
main() {
    # Set up cleanup trap
    trap cleanup EXIT

    # Show header
    log_header "Picovis CLI Installation"
    echo >&2

    # Parse arguments
    parse_args "$@"

    # Validate prefix
    if [[ -z "$INSTALL_PREFIX" ]]; then
        log_error "Install prefix cannot be empty"
        exit 1
    fi

    # Show installation info
    log_info "Installation version: $INSTALL_VERSION"
    log_info "Installation prefix: $INSTALL_PREFIX"
    echo >&2

    # Run installation steps
    detect_platform
    get_download_url
    local temp_binary
    temp_binary=$(download_binary)
    install_binary "$temp_binary"
    verify_installation
    check_path

    # Success message
    echo >&2
    log_header "Installation Complete! 🎉"
    echo >&2
    log_success "Picovis CLI has been successfully installed"
    log_info "Run 'picovis --help' to get started"
    log_info "Visit https://github.com/picovis/picovis-community for documentation"
    echo >&2
}

# Run main function if script is executed directly
# Handle both direct execution and piped execution (e.g., curl | bash)
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]] || [[ -z "${BASH_SOURCE[0]:-}" ]]; then
    main "$@"
fi
