#!/bin/bash
# CI script to format Python code with ruff

set -e

echo "=========================================="
echo "Formatting Python Code"
echo "=========================================="
echo ""

# Check if ruff is installed
if ! command -v ruff &> /dev/null; then
    echo "⚠️  ruff not found. Trying to use from uv..."
    
    # Try using uv if available
    if command -v uv &> /dev/null; then
        cd ground_control
        echo "Using ruff via uv..."
        uv run ruff format .
        uv run ruff check . --fix --select I,F,E
        echo ""
        echo "✅ Python files formatted successfully"
        exit 0
    else
        echo "❌ Neither ruff nor uv found"
        echo "Install with: pip install ruff  or  pip install uv"
        exit 1
    fi
fi

# Format with ruff
echo "📝 Formatting Python files..."
ruff format ground_control

echo ""
echo "📝 Auto-fixing linting issues..."
ruff check ground_control --fix --select I,F,E

echo ""
echo "=========================================="
echo "✅ Python files formatted successfully"
echo "=========================================="
