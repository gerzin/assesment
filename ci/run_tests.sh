#!/bin/bash
# CI script to run all tests using Bazel

set -e

echo "=========================================="
echo "Running All Tests"
echo "=========================================="
echo ""

# Run all tests in the workspace
echo "🧪 Running C++ tests..."
bazel test //onboard/tests:onboard_test --test_output=errors

echo ""
echo "🐍 Running Python tests..."
bazel test //ground_control:test_shared_lib --test_output=errors

echo ""
echo "=========================================="
echo "✅ All tests passed!"
echo "=========================================="
