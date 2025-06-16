#!/usr/bin/env python3

import re

# Read the original file
with open('install.sh', 'r') as f:
    content = f.read()

# Fix SC2034 - Add shellcheck disable for GPG_KEY_ID
content = re.sub(
    r'(# 🔒 Security Configuration\n)(readonly GPG_KEY_ID=)',
    r'\1# shellcheck disable=SC2034  # GPG_KEY_ID reserved for future GPG signature verification\n\2',
    content
)

# Fix SC2206 - Fix array assignment in version_compare function
content = re.sub(
    r'local ver1_parts=\(\$version1\)',
    r'IFS=\'.\' read -ra ver1_parts <<< "$version1"',
    content
)

content = re.sub(
    r'local ver2_parts=\(\$version2\)',
    r'IFS=\'.\' read -ra ver2_parts <<< "$version2"',
    content
)

# Fix SC2002 - Remove useless cat in checksum parsing
content = re.sub(
    r'expected_checksum=\$\(cat "\$temp_checksum" \| cut -d\' \' -f1\)',
    r'expected_checksum=$(cut -d\' \' -f1 < "$temp_checksum")',
    content
)

# Write the fixed content
with open('install.sh', 'w') as f:
    f.write(content)

print("ShellCheck issues fixed!")
