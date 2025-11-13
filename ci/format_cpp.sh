#!/bin/bash
# CI script to format C++ code with clang-format

set -e

echo "=========================================="
echo "Formatting C++ Code"
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
    echo "ERROR: clang-format not found"
    echo "Install with: sudo apt-get install clang-format"
    exit 1
fi

echo "Formatting files:"
for file in $CPP_FILES; do
    echo "  $file"
    clang-format -i "$file"
done

echo ""
echo "=========================================="
echo "C++ files formatted successfully"
echo "=========================================="
