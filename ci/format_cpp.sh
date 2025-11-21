#!/bin/bash
# CI script to format C++ code with clang-format

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print_utils.sh"

print_header "Formatting C++ Code"
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
print_success "C++ files formatted successfully"
