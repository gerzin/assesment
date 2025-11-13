#!/bin/bash
# Main CI script that runs all checks

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$PROJECT_ROOT"

echo "=========================================="
echo "Running CI Pipeline"
echo "=========================================="
echo ""
echo "Project: $(basename "$PROJECT_ROOT")"
echo "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
echo "Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
echo ""

FAILED_CHECKS=()

# 1. Check C++ formatting
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 1/5: C++ Formatting Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/check_cpp_format.sh"; then
    echo ""
else
    FAILED_CHECKS+=("C++ formatting")
fi

# 2. Check Python formatting
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 2/5: Python Formatting Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/check_python_format.sh"; then
    echo ""
else
    FAILED_CHECKS+=("Python formatting")
fi

# 3. Check Bazel formatting
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 3/5: Bazel Formatting Check"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/check_bazel_format.sh"; then
    echo ""
else
    FAILED_CHECKS+=("Bazel formatting")
fi

# 4. Build all targets
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 4/5: Build All Targets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Building all targets with Bazel..."
if bazel build //...; then
    echo ""
    echo "All targets built successfully"
else
    FAILED_CHECKS+=("Build")
fi

# 5. Run all tests
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Step 5/5: Run All Tests"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if bash "$SCRIPT_DIR/run_tests.sh"; then
    echo ""
else
    FAILED_CHECKS+=("Tests")
fi

# Summary
echo ""
echo "=========================================="
echo "CI Pipeline Summary"
echo "=========================================="
echo ""

if [ ${#FAILED_CHECKS[@]} -eq 0 ]; then
    echo "All checks passed!"
    echo ""
    echo "  [PASS] C++ formatting"
    echo "  [PASS] Python formatting"
    echo "  [PASS] Bazel formatting"
    echo "  [PASS] Build"
    echo "  [PASS] Tests"
    echo ""
    exit 0
else
    echo "ERROR: ${#FAILED_CHECKS[@]} check(s) failed:"
    echo ""
    for check in "${FAILED_CHECKS[@]}"; do
        echo "  [FAIL] $check"
    done
    echo ""
    exit 1
fi
