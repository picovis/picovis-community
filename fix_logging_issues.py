#!/usr/bin/env python3

import re

# Read the original file
with open('install.sh', 'r') as f:
    content = f.read()

# Fix SC2015 issues in logging functions by converting A && B || C to proper if-then-else
patterns = [
    (r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\]" >>".*?" 2>/dev/null \|\| true',
     lambda m: '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] INFO: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi'),
]

# Fix each logging function individually
content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] INFO: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] INFO: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] SUCCESS: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] SUCCESS: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] WARNING: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] WARNING: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] ERROR: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] ERROR: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] PROGRESS: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] PROGRESS: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

content = re.sub(
    r'    \[\[ "\$VERBOSE" == true \]\] && echo "\[.*?\] HEADER: \$1" >>".*?" 2>/dev/null \|\| true',
    '    if [[ "$VERBOSE" == true ]]; then\n        echo "[$(date \'+%Y-%m-%d %H:%M:%S\')] HEADER: $1" >>"$TEMP_DIR/install.log" 2>/dev/null || true\n    fi',
    content
)

# Write the fixed content
with open('install.sh', 'w') as f:
    f.write(content)

print("Logging function SC2015 issues fixed!")
