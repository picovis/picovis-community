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
#   - Input validation and sanitization
#   - Secure temporary file handling
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
readonly GPG_KEY_ID="YOUR_GPG_KEY_ID"  # Replace with actual GPG key ID
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
            delay=$((delay * 2))  # Exponential backoff
        fi
        
        ((attempt++))
    done
    
    log_error "Command failed after $max_attempts attempts: ${command[*]}"
    return 1
}
