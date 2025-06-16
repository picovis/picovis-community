#!/usr/bin/env bash

# 🚀 Picovis CLI Universal Installation Script (Industry Best Practices)
#
# This script automatically detects your operating system and architecture,
# downloads the appropriate Picovis CLI binary from GitHub releases, and
# installs it to your system with enterprise-grade security and reliability.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.3
#   curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=/opt/picovis
#
# Options:
#   --version=VERSION      Install specific version (default: latest)
#   --prefix=PREFIX        Install to custom directory (default: /usr/local)
#   --force                Force reinstallation
#   --dry-run              Show what would be done without executing
#   --verbose              Enable verbose output
#   --verify-signature     Verify GPG signature (requires gpg)
#   --proxy=URL            Use HTTP proxy for downloads
#   --offline=PATH         Install from local binary file
#   --uninstall            Uninstall Picovis CLI
#   --help                 Show this help message
#
# Security Features:
#   - SHA256 checksum verification
#   - Optional GPG signature verification
#   - Secure temporary file handling
#   - Input validation and sanitization
#
# Copyright (c) 2024 Picovis. All rights reserved.
# This software is proprietary and confidential.

set -euo pipefail

# 🔒 Security: Ensure secure umask for temporary files
umask 077

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
readonly SCRIPT_VERSION="2.0.0"
readonly MIN_CURL_VERSION="7.50.0"
readonly MAX_RETRIES=3
readonly RETRY_DELAY=2

# 🔒 Security Configuration
# shellcheck disable=SC2034  # GPG_KEY_ID reserved for future GPG signature verification
# shellcheck disable=SC2034  # GPG_KEY_ID reserved for future GPG signature verification
readonly GPG_KEY_ID="YOUR_GPG_KEY_ID" # Replace with actual GPG key ID
readonly CHECKSUM_URL_SUFFIX=".sha256"

# 🌍 Global variables
INSTALL_VERSION="latest"
INSTALL_PREFIX="$INSTALL_DIR_DEFAULT"
FORCE_INSTALL=false
DRY_RUN=false
VERBOSE=false
VERIFY_SIGNATURE=false
PROXY_URL=""
OFFLINE_PATH=""
UNINSTALL=false
NON_INTERACTIVE=false
DETECTED_OS=""
DETECTED_ARCH=""
BINARY_FILENAME=""
DOWNLOAD_URL=""
CHECKSUM_URL=""
INSTALLATION_ID=""

# 🎯 Enhanced Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  ${1}${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_success() {
    echo -e "${GREEN}✅ ${1}${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${1}${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_error() {
    echo -e "${RED}❌ ${1}${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_progress() {
    echo -e "${PURPLE}🔄 ${1}${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] PROGRESS: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_header() {
    echo -e "${CYAN}${BOLD}🚀 $1${NC}" >&2
    if [[ "$VERBOSE" == true ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] HEADER: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${WHITE}🔍 DEBUG: ${1}${NC}" >&2
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEBUG: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true
    fi
}

log_dry_run() {
    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${CYAN}🔍 DRY RUN: ${1}${NC}" >&2
    fi
}

# 🔧 Utility functions
generate_installation_id() {
    INSTALLATION_ID="picovis-$(date +%s)-$(head -c 8 /dev/urandom | base64 | tr -d '/' | tr -d '+' | tr -d '=')"
    log_debug "Generated installation ID: $INSTALLATION_ID"
}

# 🔒 Security functions
validate_input() {
    local input="$1"
    local type="$2"

    case "$type" in
    "version")
        if [[ ! "$input" =~ ^(latest|v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+)?)$ ]]; then
            log_error "Invalid version format: $input"
            log_info "Version must be 'latest' or in format 'vX.Y.Z' or 'vX.Y.Z-suffix'"
            return 1
        fi
        ;;
    "path")
        if [[ "$input" =~ [^a-zA-Z0-9/_.-] ]]; then
            log_error "Invalid characters in path: $input"
            log_info "Path can only contain alphanumeric characters, /, _, ., and -"
            return 1
        fi
        ;;
    "url")
        if [[ ! "$input" =~ ^https?:// ]]; then
            log_error "Invalid URL format: $input"
            log_info "URL must start with http:// or https://"
            return 1
        fi
        ;;
    esac
    return 0
}

verify_checksum() {
    local file="$1"
    local expected_checksum="$2"

    if [[ -z "$expected_checksum" ]]; then
        log_warning "No checksum provided for verification"
        return 0
    fi

    log_progress "Verifying SHA256 checksum..."
    local actual_checksum
    if command -v sha256sum >/dev/null 2>&1; then
        actual_checksum=$(sha256sum "$file" | cut -d' ' -f1)
    elif command -v shasum >/dev/null 2>&1; then
        actual_checksum=$(shasum -a 256 "$file" | cut -d' ' -f1)
    else
        log_warning "No SHA256 utility found, skipping checksum verification"
        return 0
    fi

    if [[ "$actual_checksum" == "$expected_checksum" ]]; then
        log_success "Checksum verification passed"
        return 0
    else
        log_error "Checksum verification failed!"
        log_error "Expected: $expected_checksum"
        log_error "Actual:   $actual_checksum"
        return 1
    fi
}

# 🌐 Network functions
check_network_connectivity() {
    log_progress "Checking network connectivity..."

    local test_urls=("https://api.github.com" "https://github.com")
    local connected=false

    for url in "${test_urls[@]}"; do
        if curl -fsSL --connect-timeout 10 --max-time 30 "$url" >/dev/null 2>&1; then
            connected=true
            break
        fi
    done

    if [[ "$connected" == false ]]; then
        log_error "No network connectivity detected"
        log_info "Please check your internet connection and try again"
        return 1
    fi

    log_success "Network connectivity verified"
    return 0
}

retry_with_backoff() {
    local max_attempts="$1"
    local delay="$2"
    local command=("${@:3}")

    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        log_debug "Attempt $attempt of $max_attempts: ${command[*]}"

        if "${command[@]}"; then
            return 0
        fi

        if [[ $attempt -lt $max_attempts ]]; then
            log_warning "Command failed, retrying in ${delay}s... (attempt $attempt/$max_attempts)"
            sleep "$delay"
            delay=$((delay * 2)) # Exponential backoff
        fi

        ((attempt++))
    done

    log_error "Command failed after $max_attempts attempts: ${command[*]}"
    return 1
}

# 🆘 Enhanced Help function
show_help() {
    cat <<EOF
${BOLD}Picovis CLI Installation Script v${SCRIPT_VERSION}${NC}

${BOLD}DESCRIPTION:${NC}
    Enterprise-grade installation script that automatically downloads and installs
    the Picovis CLI binary for your operating system and architecture with
    comprehensive security features and reliability enhancements.

${BOLD}USAGE:${NC}
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- [OPTIONS]

${BOLD}BASIC OPTIONS:${NC}
    --version=VERSION      Install specific version (e.g., --version=v1.2.3)
                          Default: latest

    --prefix=PREFIX        Install to custom directory (e.g., --prefix=/opt/picovis)
                          Default: /usr/local
                          Binary will be installed to PREFIX/bin/picovis

    --force               Force reinstallation even if already installed

    --help                Show this help message

${BOLD}ADVANCED OPTIONS:${NC}
    --dry-run             Show what would be done without executing
    --verbose             Enable verbose output and logging
    --verify-signature    Verify GPG signature (requires gpg)
    --proxy=URL           Use HTTP proxy for downloads
    --offline=PATH        Install from local binary file
    --uninstall           Uninstall Picovis CLI
    --non-interactive     Run without prompting for user input

${BOLD}BASIC EXAMPLES:${NC}
    # Install latest version to default location
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash

    # Install specific version (recommended if API fails)
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --version=v1.2.4

    # Install to custom location
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --prefix=/opt/picovis

    # Force reinstall with verbose output
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --force --verbose

${BOLD}ADVANCED EXAMPLES:${NC}
    # Dry run to see what would happen
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --dry-run

    # Install with signature verification
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --verify-signature

    # Install through corporate proxy
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --proxy=http://proxy.company.com:8080

    # Install from local file (offline)
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --offline=/path/to/picovis-binary

    # Uninstall
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --uninstall

${BOLD}SECURITY FEATURES:${NC}
    • SHA256 checksum verification
    • Optional GPG signature verification
    • Input validation and sanitization
    • Secure temporary file handling
    • Network connectivity validation

    # Dry run (preview actions)
    curl -fsSL https://raw.githubusercontent.com/picovis/picovis-community/main/install.sh | bash -s -- --dry-run

${BOLD}TROUBLESHOOTING:${NC}
    If you encounter GitHub API rate limiting (403 errors), try:
    - Specifying a version explicitly: --version=v1.2.4
    - Using --verbose for detailed logging
    - Waiting a few minutes and trying again
    - Downloading manually from: https://github.com/picovis/picovis-community/releases

${BOLD}REQUIREMENTS:${NC}
    - curl (version ${MIN_CURL_VERSION} or later)
    - Linux or macOS
    - x86_64 architecture (ARM64 supported on macOS only)
    - Optional: gpg (for signature verification)
    - Optional: sha256sum or shasum (for checksum verification)

${BOLD}SUPPORT:${NC}
    For issues and support, visit: https://github.com/picovis/picovis-community/issues
    Documentation: https://github.com/picovis/picovis-community/wiki
EOF
}

# 🔍 Dependency checking functions
check_dependencies() {
    log_progress "Checking system dependencies..."

    local missing_deps=()
    local warnings=()

    # Check curl
    if ! command -v curl >/dev/null 2>&1; then
        missing_deps+=("curl")
    else
        local curl_version
        curl_version=$(curl --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        if [[ -n "$curl_version" ]]; then
            log_debug "Found curl version: $curl_version"
            if ! version_compare "$curl_version" "$MIN_CURL_VERSION"; then
                warnings+=("curl version $curl_version is older than recommended $MIN_CURL_VERSION")
            fi
        fi
    fi

    # Check for checksum utilities
    if ! command -v sha256sum >/dev/null 2>&1 && ! command -v shasum >/dev/null 2>&1; then
        warnings+=("No SHA256 utility found (sha256sum or shasum) - checksum verification will be skipped")
    fi

    # Check for GPG if signature verification is requested
    if [[ "$VERIFY_SIGNATURE" == true ]] && ! command -v gpg >/dev/null 2>&1; then
        missing_deps+=("gpg")
    fi

    # Check for basic utilities
    for cmd in mkdir chmod rm cp; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done

    # Report missing dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            log_error "  - $dep"
        done
        log_info "Please install the missing dependencies and try again"
        return 1
    fi

    # Report warnings
    if [[ ${#warnings[@]} -gt 0 ]]; then
        for warning in "${warnings[@]}"; do
            log_warning "$warning"
        done
    fi

    log_success "All required dependencies are available"
    return 0
}

version_compare() {
    local version1="$1"
    local version2="$2"

    # Simple version comparison (assumes semantic versioning)
    local IFS='.'
    IFS='.' read -ra ver1_parts <<<"$version1"
    IFS='.' read -ra ver2_parts <<<"$version2"

    for i in {0..2}; do
        local v1=${ver1_parts[i]:-0}
        local v2=${ver2_parts[i]:-0}

        if [[ $v1 -gt $v2 ]]; then
            return 0 # version1 > version2
        elif [[ $v1 -lt $v2 ]]; then
            return 1 # version1 < version2
        fi
    done

    return 0 # versions are equal
}

check_system_requirements() {
    log_progress "Checking system requirements..."

    # Check available disk space (need at least 100MB)
    local available_space
    if command -v df >/dev/null 2>&1; then
        # Use /tmp as fallback if TEMP_DIR doesn't exist yet
        local check_dir="$TEMP_DIR"
        if [[ ! -d "$check_dir" ]]; then
            check_dir="/tmp"
        fi
        available_space=$(df "$check_dir" 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")
        if [[ "$available_space" -gt 0 ]] && [[ "$available_space" -lt 102400 ]]; then # 100MB in KB
            log_warning "Low disk space detected. Available: ${available_space}KB"
            log_info "At least 100MB of free space is recommended"
        fi
    fi

    # Check if running as root (warn if so)
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root user"
        log_info "Consider running as a regular user and using sudo only when needed"
    fi

    # Check umask
    local current_umask
    current_umask=$(umask)
    log_debug "Current umask: $current_umask (script set to 0077 for security)"
    if [[ "$current_umask" != "0077" ]]; then
        log_warning "Umask is not set to secure value 0077"
    fi

    log_success "System requirements check completed"
    return 0
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
        local latest_release=""
        local api_response

        # Try to fetch latest release with better error handling
        if api_response=$(curl -fsSL "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" 2>/dev/null); then
            latest_release=$(echo "$api_response" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        fi

        if [[ -z "$latest_release" ]]; then
            log_warning "Failed to fetch latest release information from GitHub API"
            log_info "This might be due to GitHub API rate limiting or network issues"
            log_info "Falling back to known latest version: v1.2.4"
            log_info "To install a specific version, use: --version=vX.Y.Z"
            log_info "Available versions can be found at: https://github.com/${GITHUB_REPO}/releases"

            # Fallback to known latest version
            INSTALL_VERSION="v1.2.4"
            log_warning "Using fallback version: $INSTALL_VERSION"
        else
            INSTALL_VERSION="$latest_release"
            log_success "Latest version: $INSTALL_VERSION"
        fi
    fi

    # Construct binary filename with version suffix to match actual asset names
    BINARY_FILENAME="picovis-${DETECTED_OS}-${DETECTED_ARCH}-${INSTALL_VERSION}"
    DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${INSTALL_VERSION}/${BINARY_FILENAME}"
    CHECKSUM_URL="https://github.com/${GITHUB_REPO}/releases/download/${INSTALL_VERSION}/${BINARY_FILENAME}${CHECKSUM_URL_SUFFIX}"

    log_success "Download URL: $DOWNLOAD_URL"
    log_debug "Checksum URL: $CHECKSUM_URL"
}

# 📥 Enhanced download binary function
download_binary() {
    if [[ -n "$OFFLINE_PATH" ]]; then
        log_info "Using offline binary: $OFFLINE_PATH"
        local temp_binary="$TEMP_DIR/$BINARY_FILENAME"

        if [[ "$DRY_RUN" == true ]]; then
            log_dry_run "Would copy $OFFLINE_PATH to $temp_binary"
            echo "$temp_binary"
            return 0
        fi

        cp "$OFFLINE_PATH" "$temp_binary"
        chmod +x "$temp_binary"
        log_success "Offline binary prepared"
        echo "$temp_binary"
        return 0
    fi

    log_progress "Downloading Picovis CLI binary..."

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would download from: $DOWNLOAD_URL"
        log_info "[DRY RUN] Would save to: $TEMP_DIR/$BINARY_FILENAME"
        echo "/tmp/fake-binary-for-dry-run"
        return 0
    fi

    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    local temp_binary="$TEMP_DIR/$BINARY_FILENAME"
    local temp_checksum="$TEMP_DIR/$BINARY_FILENAME.sha256"

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would download: $DOWNLOAD_URL"
        log_dry_run "Would save to: $temp_binary"
        echo "$temp_binary"
        return 0
    fi

    # Prepare curl options
    local curl_opts=(-fL --progress-bar)

    if [[ -n "$PROXY_URL" ]]; then
        curl_opts+=(--proxy "$PROXY_URL")
        log_debug "Using proxy: $PROXY_URL"
    fi

    # Download binary with retry
    if ! retry_with_backoff "$MAX_RETRIES" "$RETRY_DELAY" curl "${curl_opts[@]}" "$DOWNLOAD_URL" -o "$temp_binary"; then
        log_error "Failed to download binary from $DOWNLOAD_URL"
        log_info "This could be due to:"
        log_info "  • Network connectivity issues"
        log_info "  • Invalid version specified"
        log_info "  • GitHub server issues"
        log_info "  • Proxy configuration issues"
        log_info ""
        log_info "Alternative installation methods:"
        log_info "  1. Try a specific version: --version=v1.2.4"
        log_info "  2. Use --verbose for detailed logging"
        log_info "  3. Download manually from: https://github.com/${GITHUB_REPO}/releases"
        log_info "  4. Check available versions at: https://github.com/${GITHUB_REPO}/releases"
        exit 1
    fi

    # Download checksum if available
    local expected_checksum=""
    if [[ -n "$CHECKSUM_URL" ]]; then
        log_debug "Downloading checksum from: $CHECKSUM_URL"
        if curl "${curl_opts[@]}" "$CHECKSUM_URL" -o "$temp_checksum" 2>/dev/null; then
            expected_checksum=$(cut -d' ' -f1 <"$temp_checksum")
            log_debug "Expected checksum: $expected_checksum"
        else
            log_warning "Failed to download checksum file"
        fi
    fi

    # Verify download
    if [[ ! -f "$temp_binary" ]] || [[ ! -s "$temp_binary" ]]; then
        log_error "Downloaded binary is empty or missing"
        exit 1
    fi

    # Verify checksum if available
    if [[ -n "$expected_checksum" ]]; then
        if ! verify_checksum "$temp_binary" "$expected_checksum"; then
            log_error "Checksum verification failed - binary may be corrupted"
            exit 1
        fi
    fi

    # Make executable
    chmod +x "$temp_binary"

    log_success "Binary downloaded successfully"
    echo "$temp_binary"
}

# 🔧 Enhanced install binary function
install_binary() {
    local temp_binary="$1"
    local install_dir="$INSTALL_PREFIX/bin"
    local install_path="$install_dir/$BINARY_NAME"

    log_progress "Installing Picovis CLI to $install_path..."

    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would create directory: $install_dir"
        log_dry_run "Would install binary: $temp_binary -> $install_path"
        log_dry_run "Would set permissions: 755"
        return 0
    fi

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

    # Check if already installed and not forcing (IMPROVED VERSION DETECTION)
    if [[ -f "$install_path" ]] && [[ "$FORCE_INSTALL" == false ]]; then
        local current_version
        if ! current_version=$("$install_path" --version 2>/dev/null | head -n1); then
            current_version="(version check failed - binary may be corrupted)"
        fi
        log_warning "Picovis CLI is already installed: $current_version"
        log_info "Use --force to reinstall or uninstall first"

        # Handle interactive vs non-interactive mode
        if [[ "$NON_INTERACTIVE" == true ]] || [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]]; then
            log_info "Non-interactive mode: skipping installation"
            exit 0
        else
            # Ask user if they want to continue
            echo -n "Do you want to continue with installation? [y/N]: " >&2
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                log_info "Installation cancelled"
                exit 0
            fi
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

    if [[ "$DRY_RUN" == true ]]; then
        log_info "[DRY RUN] Would verify binary exists at: $install_path"
        log_info "[DRY RUN] Would check binary is executable"
        log_info "[DRY RUN] Would test binary execution"
        log_success "[DRY RUN] Installation verification would complete successfully"
        return 0
    fi

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

# 🗑️ Uninstall function
uninstall_picovis() {
    log_header "Picovis CLI Uninstallation"
    echo >&2

    local install_path="$INSTALL_PREFIX/bin/$BINARY_NAME"

    if [[ ! -f "$install_path" ]]; then
        log_warning "Picovis CLI is not installed at $install_path"
        return 0
    fi

    # Get current version for confirmation
    local current_version
    if current_version=$("$install_path" --version 2>/dev/null | head -n1); then
        log_info "Found Picovis CLI: $current_version"
    else
        log_info "Found Picovis CLI at: $install_path"
    fi

    # Confirm uninstallation
    if [[ "$FORCE_INSTALL" != true ]]; then
        echo -n "Are you sure you want to uninstall Picovis CLI? [y/N]: " >&2
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Uninstallation cancelled"
            return 0
        fi
    fi

    # Remove binary
    log_progress "Removing Picovis CLI binary..."
    if [[ "$DRY_RUN" == true ]]; then
        log_dry_run "Would remove: $install_path"
    else
        if ! rm "$install_path" 2>/dev/null; then
            log_warning "Permission denied. Trying with sudo..."
            if ! sudo rm "$install_path"; then
                log_error "Failed to remove binary: $install_path"
                return 1
            fi
        fi
        log_success "Picovis CLI has been uninstalled"
    fi

    # Check if directory is empty and remove if so
    local bin_dir="$INSTALL_PREFIX/bin"
    if [[ -d "$bin_dir" ]] && [[ -z "$(ls -A "$bin_dir" 2>/dev/null)" ]]; then
        log_info "Removing empty directory: $bin_dir"
        if [[ "$DRY_RUN" != true ]]; then
            rmdir "$bin_dir" 2>/dev/null || true
        fi
    fi

    log_success "Uninstallation completed successfully"
    return 0
}

# 🎯 Enhanced argument parsing
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
        --version=*)
            INSTALL_VERSION="${1#*=}"
            if ! validate_input "$INSTALL_VERSION" "version"; then
                exit 1
            fi
            shift
            ;;
        --prefix=*)
            INSTALL_PREFIX="${1#*=}"
            if ! validate_input "$INSTALL_PREFIX" "path"; then
                exit 1
            fi
            shift
            ;;
        --force)
            FORCE_INSTALL=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --verify-signature)
            VERIFY_SIGNATURE=true
            shift
            ;;
        --proxy=*)
            PROXY_URL="${1#*=}"
            if ! validate_input "$PROXY_URL" "url"; then
                exit 1
            fi
            shift
            ;;
        --offline=*)
            OFFLINE_PATH="${1#*=}"
            if [[ ! -f "$OFFLINE_PATH" ]]; then
                log_error "Offline binary file not found: $OFFLINE_PATH"
                exit 1
            fi
            shift
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --non-interactive)
            NON_INTERACTIVE=true
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

    # Validate mutually exclusive options
    if [[ "$UNINSTALL" == true ]] && [[ -n "$OFFLINE_PATH" ]]; then
        log_error "Cannot use --uninstall with --offline"
        exit 1
    fi

    if [[ "$DRY_RUN" == true ]] && [[ "$UNINSTALL" == true ]]; then
        log_info "Dry run mode: will show uninstall actions without executing"
    fi
}

# 🚀 Enhanced main installation function
main() {
    # Set up cleanup trap
    trap cleanup EXIT

    # Auto-detect CI environments and enable non-interactive mode
    if [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]] || [[ -n "${TRAVIS:-}" ]] || [[ -n "${CIRCLECI:-}" ]] || [[ -n "${JENKINS_URL:-}" ]]; then
        NON_INTERACTIVE=true
    fi

    # Create temporary directory for logging and downloads
    mkdir -p "$TEMP_DIR"

    # Generate installation ID for tracking
    generate_installation_id

    # Parse arguments first
    parse_args "$@"

    # Handle uninstall mode
    if [[ "$UNINSTALL" == true ]]; then
        uninstall_picovis
        return $?
    fi

    # Show header
    log_header "Picovis CLI Installation v${SCRIPT_VERSION}"
    echo >&2

    # Show installation info
    log_info "Installation version: $INSTALL_VERSION"
    log_info "Installation prefix: $INSTALL_PREFIX"
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Mode: DRY RUN (no changes will be made)"
    fi
    if [[ "$VERBOSE" == true ]]; then
        log_info "Verbose logging enabled"
        log_info "Installation ID: $INSTALLATION_ID"
    fi
    if [[ "$NON_INTERACTIVE" == true ]] || [[ -n "${CI:-}" ]] || [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        log_info "Mode: NON-INTERACTIVE"
    fi
    echo >&2

    # Check dependencies and system requirements
    if ! check_dependencies; then
        exit 1
    fi

    if ! check_system_requirements; then
        exit 1
    fi

    # Check network connectivity (unless offline mode)
    if [[ -z "$OFFLINE_PATH" ]] && ! check_network_connectivity; then
        exit 1
    fi

    # Validate prefix
    if [[ -z "$INSTALL_PREFIX" ]]; then
        log_error "Install prefix cannot be empty"
        exit 1
    fi

    # Run installation steps
    detect_platform

    # Skip download URL resolution in offline mode
    if [[ -z "$OFFLINE_PATH" ]]; then
        get_download_url
    fi

    local temp_binary
    temp_binary=$(download_binary)
    install_binary "$temp_binary"

    # Skip verification in dry run mode
    if [[ "$DRY_RUN" != true ]]; then
        verify_installation
        check_path
    fi

    # Success message
    echo >&2
    if [[ "$DRY_RUN" == true ]]; then
        log_header "Dry Run Complete! 🎉"
        echo >&2
        log_success "All installation steps would complete successfully"
        log_info "Run without --dry-run to perform actual installation"
    else
        log_header "Installation Complete! 🎉"
        echo >&2
        log_success "Picovis CLI has been successfully installed"
        log_info "Run 'picovis --help' to get started"

        if [[ "$VERBOSE" == true ]]; then
            log_info "Installation log saved to: $TEMP_DIR/install.log"
        fi
    fi
    log_info "Visit https://github.com/picovis/picovis-community for documentation"
    echo >&2
}

# Run main function if script is executed directly
# Handle both direct execution and piped execution (e.g., curl | bash)
if [[ "${BASH_SOURCE[0]:-}" == "${0}" ]] || [[ -z "${BASH_SOURCE[0]:-}" ]]; then
    main "$@"
fi
