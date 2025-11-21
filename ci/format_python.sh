#!/bin/bash
# CI script to format Python code with ruff

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print_utils.sh"

print_header "Formatting Python Code"
echo ""

# Check if ruff is installed
if ! command -v ruff &> /dev/null; then
    echo "WARNING: ruff not found. Trying to use from uv..."

    if command -v uv &> /dev/null; then
        cd ground_control
        echo "Using ruff via uv..."
        uv run ruff format .
        uv run ruff check . --fix --select I,F,E
        echo ""
        echo "Python files formatted successfully"
        exit 0
    else
        echo "ERROR: Neither ruff nor uv found"
        echo "Install with: pip install ruff  or  pip install uv"
        exit 1
    fi
fi

echo "Formatting Python files..."
ruff format ground_control

echo ""
echo "Auto-fixing linting issues..."
ruff check ground_control --fix --select I,F,E

echo ""
print_success "Python files formatted successfully"
