#!/bin/bash

# Test script to verify CI fixes for macOS-12 hanging issue

set -e

echo "🧪 Testing CI Fixes for macOS-12 Hanging Issue"
echo "=============================================="
echo

# Test 1: Dry run mode
echo "1️⃣ Testing dry-run mode..."
if timeout 30 ./install.sh --dry-run --version=v1.2.4 >/dev/null 2>&1; then
    echo "✅ Dry-run mode works correctly"
else
    echo "❌ Dry-run mode failed or timed out"
    exit 1
fi
echo

# Test 2: Non-interactive mode
echo "2️⃣ Testing non-interactive mode..."
if timeout 30 ./install.sh --non-interactive --dry-run --version=v1.2.4 >/dev/null 2>&1; then
    echo "✅ Non-interactive mode works correctly"
else
    echo "❌ Non-interactive mode failed or timed out"
    exit 1
fi
echo

# Test 3: CI environment detection
echo "3️⃣ Testing CI environment detection..."
export CI=true
if timeout 30 ./install.sh --dry-run --version=v1.2.4 2>&1 | grep -q "NON-INTERACTIVE"; then
    echo "✅ CI environment detection works correctly"
else
    echo "❌ CI environment detection failed"
    exit 1
fi
unset CI
echo

# Test 4: GitHub Actions environment detection
echo "4️⃣ Testing GitHub Actions environment detection..."
export GITHUB_ACTIONS=true
if timeout 30 ./install.sh --dry-run --version=v1.2.4 2>&1 | grep -q "NON-INTERACTIVE"; then
    echo "✅ GitHub Actions environment detection works correctly"
else
    echo "❌ GitHub Actions environment detection failed"
    exit 1
fi
unset GITHUB_ACTIONS
echo

# Test 5: Help command timeout
echo "5️⃣ Testing help command doesn't hang..."
if timeout 10 ./install.sh --help >/dev/null 2>&1; then
    echo "✅ Help command completes quickly"
else
    echo "❌ Help command timed out"
    exit 1
fi
echo

# Test 6: Platform detection timeout
echo "6️⃣ Testing platform detection doesn't hang..."
if timeout 30 ./install.sh --dry-run 2>&1 | grep -q "Detected platform:"; then
    echo "✅ Platform detection works correctly"
else
    echo "❌ Platform detection failed or timed out"
    exit 1
fi
echo

# Test 7: Invalid arguments handling
echo "7️⃣ Testing invalid arguments handling..."
if timeout 10 ./install.sh --invalid-option 2>/dev/null; then
    echo "❌ Invalid arguments should fail"
    exit 1
else
    echo "✅ Invalid arguments handled correctly"
fi
echo

echo "🎉 All CI fixes are working correctly!"
echo
echo "🔧 Key improvements:"
echo "   • Added --dry-run mode to prevent actual downloads/installations"
echo "   • Added --non-interactive mode to prevent hanging on prompts"
echo "   • Added automatic CI environment detection"
echo "   • Added timeouts to prevent infinite hanging"
echo "   • Improved error handling and graceful failures"
echo
echo "✅ The macOS-12 hanging issue should now be resolved!"
