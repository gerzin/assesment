#!/bin/bash
# CI script to check Bazel file formatting with buildifier

set -e

# Source utility functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print_utils.sh"

print_header "Checking Bazel File Formatting"
echo ""

# Find all Bazel files
BAZEL_FILES=$(find . -type f \
    \( -name "BUILD" -o -name "BUILD.bazel" -o -name "WORKSPACE" -o -name "WORKSPACE.bazel" -o -name "*.bzl" -o -name "MODULE.bazel" \) \
    ! -path "./bazel-*" \
    ! -path "./.git/*")

if [ -z "$BAZEL_FILES" ]; then
    echo "No Bazel files found to format"
    exit 0
fi

if ! command -v buildifier &> /dev/null; then
    echo "WARNING: buildifier not found. Skipping Bazel formatting check."
    exit 0
fi

echo "Found Bazel files to check:"
echo "$BAZEL_FILES"
echo ""

# Check formatting (dry-run with -mode=check)
NEEDS_FORMAT=0
for file in $BAZEL_FILES; do
    if ! buildifier -mode=check "$file" 2>/dev/null; then
        echo "FAIL: $file needs formatting"
        NEEDS_FORMAT=1
    else
        echo "PASS: $file"
    fi
done

echo ""
if [ $NEEDS_FORMAT -eq 1 ]; then
    print_error "Some files need formatting"
    echo ""
    echo "To fix, run: ci/format_bazel.sh"
    exit 1
else
    print_success "All Bazel files are properly formatted"
fi
