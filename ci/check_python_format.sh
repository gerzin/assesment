#!/bin/bash
# CI script to check Python code formatting with ruff

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print_utils.sh"

print_header "Checking Python Code Formatting"
echo ""

PYTHON_FILES=$(find ground_control -type f -name "*.py" ! -path "*/.venv/*" ! -path "*/__pycache__/*")

if [ -z "$PYTHON_FILES" ]; then
    echo "No Python files found to format"
    exit 0
fi

echo "Found Python files to check:"
echo "$PYTHON_FILES"
echo ""

if ! command -v ruff &> /dev/null; then
    echo "WARNING: ruff not found. Trying to use from uv..."

    if command -v uv &> /dev/null; then
        cd ground_control
        echo "Using ruff via uv..."
        uv run ruff check . --select I,F,E
        uv run ruff format --check .
        exit $?
    else
        echo "WARNING: Neither ruff nor uv found. Skipping Python formatting check."
        echo "Install with: pip install ruff  or  pip install uv"
        exit 0
    fi
fi

echo "Checking formatting..."
if ! ruff format --check ground_control; then
    echo ""
    echo "ERROR: Python files need formatting"
    echo "To fix, run: ci/format_python.sh"
    exit 1
fi

echo ""
echo "Checking linting..."
if ! ruff check ground_control --select I,F,E; then
    echo ""
    echo "ERROR: Python files have linting issues"
    exit 1
fi

echo ""
print_success "All Python files are properly formatted"
