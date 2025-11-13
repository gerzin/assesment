#!/bin/bash
# CI script to check C++ code formatting with clang-format

set -e

echo "=========================================="
echo "Checking C++ Code Formatting"
echo "=========================================="
echo ""

# Find all C++ files
CPP_FILES=$(find onboard third_party/argparse -type f \( -name "*.cpp" -o -name "*.hpp" \) ! -path "*/third_party/argparse/include/*")

if [ -z "$CPP_FILES" ]; then
    echo "No C++ files found to format"
    exit 0
fi

# Check if clang-format is installed
if ! command -v clang-format &> /dev/null; then
    echo "WARNING: clang-format not found. Skipping C++ formatting check."
    echo "Install with: sudo apt-get install clang-format"
    exit 0
fi

echo "Found C++ files to check:"
echo "$CPP_FILES"
echo ""

# Check formatting (dry-run)
NEEDS_FORMAT=0
for file in $CPP_FILES; do
    if ! clang-format --dry-run --Werror "$file" 2>/dev/null; then
        echo "FAIL: $file needs formatting"
        NEEDS_FORMAT=1
    else
        echo "PASS: $file"
    fi
done

echo ""
if [ $NEEDS_FORMAT -eq 1 ]; then
    echo "=========================================="
    echo "ERROR: Some files need formatting"
    echo "=========================================="
    echo ""
    echo "To fix, run: ci/format_cpp.sh"
    exit 1
else
    echo "=========================================="
    echo "All C++ files are properly formatted"
    echo "=========================================="
fi
