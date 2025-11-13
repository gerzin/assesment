#!/bin/bash
# CI script to check Python code formatting with ruff

set -e

echo "=========================================="
echo "Checking Python Code Formatting"
echo "=========================================="
echo ""

# Find all Python files
PYTHON_FILES=$(find ground_control -type f -name "*.py")

if [ -z "$PYTHON_FILES" ]; then
    echo "No Python files found to format"
    exit 0
fi

echo "Found Python files to check:"
echo "$PYTHON_FILES"
echo ""

# Check if ruff is installed
if ! command -v ruff &> /dev/null; then
    echo "⚠️  ruff not found. Trying to use from uv..."
    
    # Try using uv if available
    if command -v uv &> /dev/null; then
        cd ground_control
        echo "Using ruff via uv..."
        uv run ruff check . --select I,F,E
        uv run ruff format --check .
        exit $?
    else
        echo "⚠️  Neither ruff nor uv found. Skipping Python formatting check."
        echo "Install with: pip install ruff  or  pip install uv"
        exit 0
    fi
fi

# Check formatting and linting
echo "🔍 Checking formatting..."
if ! ruff format --check ground_control; then
    echo ""
    echo "❌ Python files need formatting"
    echo "To fix, run: ci/format_python.sh"
    exit 1
fi

echo ""
echo "🔍 Checking linting..."
if ! ruff check ground_control --select I,F,E; then
    echo ""
    echo "❌ Python files have linting issues"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ All Python files are properly formatted"
echo "=========================================="
