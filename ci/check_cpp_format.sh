#!/bin/bash
# CI script to check C++ code formatting with clang-format

set -e

echo "=========================================="
echo "Checking C++ Code Formatting"
echo "=========================================="
echo ""

# Find all C++ files (exclude third_party, bazel-*, and hidden directories)
CPP_FILES=$(find . -type f \
    \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" -o -name "*.cc" -o -name "*.cxx" -o -name "*.hxx" -o -name "*.c++" -o -name "*.h++" \) \
    ! -path "./third_party/*" \
    ! -path "./bazel-*" \
    ! -path "./.git/*" \
    ! -path "*/.venv/*" \
    ! -path "*/__pycache__/*")

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
