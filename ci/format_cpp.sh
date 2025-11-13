#!/bin/bash
# CI script to format C++ code with clang-format

set -e

echo "=========================================="
echo "Formatting C++ Code"
echo "=========================================="
echo ""

# Find all C++ files (exclude third_party includes)
CPP_FILES=$(find onboard third_party/argparse -type f \( -name "*.cpp" -o -name "*.hpp" \) ! -path "*/third_party/argparse/include/*")

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
