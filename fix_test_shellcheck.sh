#!/bin/bash

# Fix ShellCheck issues in test_install.sh

cd /home/robert/code/picovis-community

# 1. Add shellcheck disable for unused color variables
sed -i '/^readonly PURPLE=/i # shellcheck disable=SC2034  # Color variables may be used in future' test_install.sh
sed -i '/^readonly WHITE=/i # shellcheck disable=SC2034  # Color variables may be used in future' test_install.sh

# 2. Add shellcheck disable for functions that appear unreachable but are called indirectly
sed -i '/^test_warning() {/i # shellcheck disable=SC2317  # Function called indirectly via run_test' test_install.sh
sed -i '/^cleanup_test() {/i # shellcheck disable=SC2317  # Function called indirectly via trap' test_install.sh

# 3. Add shellcheck disable for all test functions that appear unreachable
for func in test_script_syntax test_shellcheck_compliance test_help_option test_dry_run_mode test_invalid_version test_invalid_prefix test_invalid_proxy test_verbose_mode test_uninstall_dry_run test_offline_nonexistent_file test_mutually_exclusive_options test_version_validation test_platform_detection test_dependency_checking test_network_connectivity test_input_validation test_logging_functions test_retry_mechanism; do
    sed -i "/^${func}() {/i # shellcheck disable=SC2317  # Function called indirectly via run_test" test_install.sh
done

echo "Test script ShellCheck issues fixed!"
