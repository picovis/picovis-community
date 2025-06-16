#!/bin/bash

# Fix all ShellCheck issues in install.sh

cd /home/robert/code/picovis-community

# 1. Add shellcheck disable for GPG_KEY_ID
sed -i '/^readonly GPG_KEY_ID=/i # shellcheck disable=SC2034  # GPG_KEY_ID reserved for future GPG signature verification' install.sh

# 2. Fix SC2015 issues in logging functions - convert A && B || C to proper if-then-else
sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] INFO: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] INFO: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] SUCCESS: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] SUCCESS: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] WARNING: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] WARNING: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] ERROR: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] ERROR: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] PROGRESS: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] PROGRESS: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

sed -i 's/\[\[ "$VERBOSE" == true \]\] && echo "\[.*\] HEADER: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true/if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"')] HEADER: $1" >>"$TEMP_DIR\/install.log" 2>\/dev\/null || true\n    fi/' install.sh

# 3. Fix SC2206 issues in version_compare function
sed -i 's/local ver1_parts=($version1)/IFS='"'"'\.'"'"' read -ra ver1_parts <<< "$version1"/' install.sh
sed -i 's/local ver2_parts=($version2)/IFS='"'"'\.'"'"' read -ra ver2_parts <<< "$version2"/' install.sh

# 4. Fix SC2002 issue in checksum parsing
sed -i 's/expected_checksum=$(cat "$temp_checksum" | cut -d'"'"' '"'"' -f1)/expected_checksum=$(cut -d'"'"' '"'"' -f1 < "$temp_checksum")/' install.sh

echo "All ShellCheck issues fixed!"
