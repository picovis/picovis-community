#!/bin/bash
set -euo pipefail

echo "=== macOS Debug Test ==="
echo "OS: $(uname -s)"
echo "Arch: $(uname -m)"

# Test platform detection logic
case "$(uname -s)" in
Linux*)
    DETECTED_OS="linux"
    ;;
Darwin*)
    DETECTED_OS="macos"
    ;;
*)
    echo "Unsupported OS: $(uname -s)"
    exit 1
    ;;
esac

case "$(uname -m)" in
x86_64 | amd64)
    DETECTED_ARCH="x64"
    ;;
arm64 | aarch64)
    if [[ "$DETECTED_OS" == "macos" ]]; then
        DETECTED_ARCH="arm64"
    else
        echo "ARM64 only supported on macOS"
        exit 1
    fi
    ;;
*)
    echo "Unsupported arch: $(uname -m)"
    exit 1
    ;;
esac

echo "Detected platform: ${DETECTED_OS}-${DETECTED_ARCH}"
