#!/usr/bin/env bash

# 🧪 Comprehensive Test Suite for Picovis CLI Installation Script
#
# This script tests all aspects of the installation script to ensure
# it follows industry best practices and handles edge cases properly.
#
# Usage:
#   ./test_install.sh
#   ./test_install.sh --verbose
#   ./test_install.sh --test-name=specific_test
#
# Copyright (c) 2024 Picovis. All rights reserved.

set -euo pipefail

# 🎨 Colors for test output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
# shellcheck disable=SC2034  # Color variables may be used in future
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
# shellcheck disable=SC2034  # Color variables may be used in future
readonly WHITE='\033[1;37m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

# 📊 Test configuration
readonly SCRIPT_PATH="./install.sh"
readonly TEST_PREFIX="/tmp/picovis-test-$$"
readonly VERBOSE=${VERBOSE:-false}
SPECIFIC_TEST=""

# 📈 Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# 🎯 Test logging functions
test_log() {
    echo -e "${BLUE}[TEST]${NC} $1" >&2
}

test_success() {
    echo -e "${GREEN}[PASS]${NC} $1" >&2
    ((TESTS_PASSED++))
}

test_fail() {
    echo -e "${RED}[FAIL]${NC} $1" >&2
    ((TESTS_FAILED++))
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

test_header() {
    echo -e "${CYAN}${BOLD}🧪 $1${NC}" >&2
}

# 🔧 Test utilities
run_test() {
    local test_name="$1"
    local test_function="$2"

    if [[ -n "$SPECIFIC_TEST" ]] && [[ "$test_name" != "$SPECIFIC_TEST" ]]; then
        return 0
    fi

    ((TESTS_RUN++))
    test_log "Running: $test_name"

    if $test_function; then
        test_success "$test_name"
    else
        test_fail "$test_name"
    fi
}

# shellcheck disable=SC2317  # Function called indirectly via trap
cleanup_test() {
    rm -rf "$TEST_PREFIX" 2>/dev/null || true
}

# 🧪 Test functions

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_script_syntax() {
    bash -n "$SCRIPT_PATH"
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_shellcheck_compliance() {
    if command -v shellcheck >/dev/null 2>&1; then
        shellcheck "$SCRIPT_PATH"
    else
        test_warning "shellcheck not available, skipping"
        return 0
    fi
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_help_option() {
    "$SCRIPT_PATH" --help >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_dry_run_mode() {
    "$SCRIPT_PATH" --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_invalid_version() {
    ! "$SCRIPT_PATH" --version="invalid.version" --dry-run 2>/dev/null
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_invalid_prefix() {
    ! "$SCRIPT_PATH" --prefix="/invalid|path" --dry-run 2>/dev/null
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_invalid_proxy() {
    ! "$SCRIPT_PATH" --proxy="not-a-url" --dry-run 2>/dev/null
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_verbose_mode() {
    "$SCRIPT_PATH" --verbose --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_uninstall_dry_run() {
    "$SCRIPT_PATH" --uninstall --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_offline_nonexistent_file() {
    ! "$SCRIPT_PATH" --offline="/nonexistent/file" --dry-run 2>/dev/null
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_mutually_exclusive_options() {
    ! "$SCRIPT_PATH" --uninstall --offline="/tmp/fake" --dry-run 2>/dev/null
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_version_validation() {
    "$SCRIPT_PATH" --version="v1.2.3" --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1 &&
        "$SCRIPT_PATH" --version="v1.2.3-beta" --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1 &&
        "$SCRIPT_PATH" --version="latest" --dry-run --prefix="$TEST_PREFIX" >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_platform_detection() {
    # Test that platform detection doesn't fail
    bash -c 'source '"$SCRIPT_PATH"'; detect_platform' >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_dependency_checking() {
    # Test dependency checking function
    bash -c 'source '"$SCRIPT_PATH"'; check_dependencies' >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_network_connectivity() {
    # Test network connectivity check
    bash -c 'source '"$SCRIPT_PATH"'; check_network_connectivity' >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_input_validation() {
    # Test input validation functions
    bash -c 'source '"$SCRIPT_PATH"'; validate_input "v1.2.3" "version"' &&
        bash -c 'source '"$SCRIPT_PATH"'; validate_input "/usr/local" "path"' &&
        bash -c 'source '"$SCRIPT_PATH"'; validate_input "https://example.com" "url"'
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_logging_functions() {
    # Test that logging functions don't crash
    bash -c 'source '"$SCRIPT_PATH"'; log_info "test"; log_success "test"; log_warning "test"; log_error "test"' >/dev/null 2>&1
}

# shellcheck disable=SC2317  # Function called indirectly via run_test
test_retry_mechanism() {
    # Test retry with backoff function
    bash -c 'source '"$SCRIPT_PATH"'; retry_with_backoff 2 1 true' >/dev/null 2>&1 &&
        ! bash -c 'source '"$SCRIPT_PATH"'; retry_with_backoff 2 1 false' >/dev/null 2>&1
}

# 🚀 Main test runner
main() {
    test_header "Picovis CLI Installation Script Test Suite"
    echo >&2

    # Check if script exists
    if [[ ! -f "$SCRIPT_PATH" ]]; then
        test_fail "Installation script not found: $SCRIPT_PATH"
        exit 1
    fi

    # Set up cleanup
    trap cleanup_test EXIT

    # Run tests
    test_log "Starting test execution..."
    echo >&2

    # Syntax and compliance tests
    run_test "script_syntax" test_script_syntax
    run_test "shellcheck_compliance" test_shellcheck_compliance

    # Basic functionality tests
    run_test "help_option" test_help_option
    run_test "dry_run_mode" test_dry_run_mode
    run_test "verbose_mode" test_verbose_mode
    run_test "uninstall_dry_run" test_uninstall_dry_run

    # Input validation tests
    run_test "invalid_version" test_invalid_version
    run_test "invalid_prefix" test_invalid_prefix
    run_test "invalid_proxy" test_invalid_proxy
    run_test "offline_nonexistent_file" test_offline_nonexistent_file
    run_test "mutually_exclusive_options" test_mutually_exclusive_options
    run_test "version_validation" test_version_validation
    run_test "input_validation" test_input_validation

    # Core functionality tests
    run_test "platform_detection" test_platform_detection
    run_test "dependency_checking" test_dependency_checking
    run_test "network_connectivity" test_network_connectivity
    run_test "logging_functions" test_logging_functions
    run_test "retry_mechanism" test_retry_mechanism

    # Results
    echo >&2
    test_header "Test Results"
    echo >&2
    test_log "Tests run: $TESTS_RUN"
    test_log "Tests passed: $TESTS_PASSED"
    test_log "Tests failed: $TESTS_FAILED"
    echo >&2

    if [[ $TESTS_FAILED -eq 0 ]]; then
        test_success "All tests passed! ✅"
        exit 0
    else
        test_fail "Some tests failed! ❌"
        exit 1
    fi
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
    --verbose)
        VERBOSE=true
        shift
        ;;
    --test-name=*)
        SPECIFIC_TEST="${1#*=}"
        shift
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: $0 [--verbose] [--test-name=TEST_NAME]" >&2
        exit 1
        ;;
    esac
done

# Run main function
main "$@"
