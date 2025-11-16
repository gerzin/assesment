#!/bin/bash
# CI script to format Bazel files with buildifier

set -e

echo "=========================================="
echo "Formatting Bazel Files"
echo "=========================================="
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
    echo "ERROR: buildifier not found"
    exit 1
fi

echo "Formatting files:"
for file in $BAZEL_FILES; do
    echo "  $file"
    buildifier -mode=fix "$file"
done

echo ""
echo "=========================================="
echo "Bazel files formatted successfully"
echo "=========================================="
