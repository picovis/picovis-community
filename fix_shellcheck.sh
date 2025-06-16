#!/bin/bash

# Fix SC2015 issues in logging functions
sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\]" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] INFO: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null; fi/' install.sh

# Fix SC2206 issues in version_compare function
sed -i 's/local ver1_parts=($version1)/IFS='"'"'.'"'"' read -ra ver1_parts <<< "$version1"/' install.sh
sed -i 's/local ver2_parts=($version2)/IFS='"'"'.'"'"' read -ra ver2_parts <<< "$version2"/' install.sh

# Fix SC2002 issue in checksum parsing
sed -i 's/expected_checksum=$(cat "$temp_checksum" | cut -d'"'"' '"'"' -f1)/expected_checksum=$(cut -d'"'"' '"'"' -f1 < "$temp_checksum")/' install.sh

echo "ShellCheck fixes applied"
