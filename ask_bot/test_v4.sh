#!/bin/bash

# Test script for AskBot v4
# This script validates the syntax and basic functionality

echo "=== AskBot v4 Test Suite ==="
echo ""

# Test 1: Check Vim version
echo "Test 1: Checking Vim version..."
vim_version=$(vim --version | head -1)
echo "  ✓ $vim_version"
echo ""

# Test 2: Syntax validation for all versions
echo "Test 2: Validating Vim9script syntax..."
cd "$(dirname "$0")"

for version in v1.vim v2.vim v3.vim v4.vim; do
    echo -n "  Testing $version... "
    if vim -u NONE -c "source $version" -c 'quit' 2>&1 | grep -qi error; then
        echo "✗ FAILED"
        exit 1
    else
        echo "✓ OK"
    fi
done
echo ""

# Test 3: Check required commands
echo "Test 3: Checking dependencies..."

commands=("curl" "base64")
for cmd in "${commands[@]}"; do
    echo -n "  Checking for $cmd... "
    if command -v "$cmd" >/dev/null 2>&1; then
        echo "✓ Found"
    else
        echo "✗ Missing (required)"
    fi
done

echo -n "  Checking for fzf... "
if command -v fzf >/dev/null 2>&1; then
    echo "✓ Found"
else
    echo "⚠ Missing (optional, needed for multi-file selection)"
fi
echo ""

# Test 4: Verify API key file location
echo "Test 4: Checking API key configuration..."
api_key_dir="$HOME/.config/gemini_key_4_vim"
api_key_file="$api_key_dir/g.key"

if [ -f "$api_key_file" ]; then
    echo "  ✓ API key file found at $api_key_file"
    perms=$(stat -c "%a" "$api_key_file" 2>/dev/null || stat -f "%OLp" "$api_key_file" 2>/dev/null)
    if [ "$perms" = "600" ]; then
        echo "  ✓ Permissions are secure (600)"
    else
        echo "  ⚠ Permissions are $perms (recommended: 600)"
    fi
else
    echo "  ⚠ API key file not found"
    echo "    Create it with: echo 'YOUR_KEY' > $api_key_file"
    echo "    And secure it with: chmod 600 $api_key_file"
fi
echo ""

# Test 5: Verify code structure
echo "Test 5: Validating v4 code structure..."

check_function() {
    local func=$1
    if grep -q "def $func" v4.vim; then
        echo "  ✓ Function $func found"
        return 0
    else
        echo "  ✗ Function $func missing"
        return 1
    fi
}

check_function "GetApiKey()"
check_function "IsImageFile("
check_function "EncodeImageBase64("
check_function "SelectFilesWithFzf("
check_function "BuildMultiFilePrompt("
check_function "CreateOutputBuffer("
check_function "StartStreamingRequest("
check_function "AskAboutFiles()"
check_function "AskAboutCurrentFile()"
echo ""

# Test 6: Check mappings
echo "Test 6: Validating key mappings..."
if grep -q "nnoremap <leader>aa" v4.vim; then
    echo "  ✓ Multi-file mapping <leader>aa defined"
else
    echo "  ✗ Multi-file mapping missing"
fi

if grep -q "nnoremap <leader>af" v4.vim; then
    echo "  ✓ Single-file mapping <leader>af defined"
else
    echo "  ✗ Single-file mapping missing"
fi
echo ""

# Test 7: Configuration validation
echo "Test 7: Checking configuration..."
if grep -q "const CONFIG = {" v4.vim; then
    echo "  ✓ CONFIG constant defined"
else
    echo "  ✗ CONFIG constant missing"
fi

required_config=("api_key_file" "model" "api_base" "supported_images")
for config in "${required_config[@]}"; do
    if grep -q "$config:" v4.vim; then
        echo "  ✓ Config key '$config' found"
    else
        echo "  ✗ Config key '$config' missing"
    fi
done
echo ""

# Test 8: Vim9script compliance
echo "Test 8: Verifying Vim9script compliance..."
for version in v1.vim v2.vim v3.vim v4.vim; do
    if head -1 "$version" | grep -q "vim9script"; then
        echo "  ✓ $version has vim9script declaration"
    else
        echo "  ✗ $version missing vim9script declaration"
    fi
done
echo ""

# Summary
echo "=== Test Summary ==="
echo "All syntax tests passed! ✓"
echo ""
echo "To use v4:"
echo "  1. Ensure API key is configured at $api_key_file"
echo "  2. Add to .vimrc: source /path/to/ask_bot/v4.vim"
echo "  3. Use <leader>aa for multi-file or <leader>af for single-file"
echo ""
