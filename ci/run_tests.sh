#!/bin/bash
# CI script to run all tests using Bazel

set -e

echo "=========================================="
echo "Running All Tests"
echo "=========================================="
echo ""

# Run all tests in the workspace
# Bazel will automatically discover and run all tests,
# cache results, and only re-run what changed
echo "🧪 Running all tests..."
bazel test //... --test_output=errors

echo ""
echo "=========================================="
echo "✅ All tests passed!"
echo "=========================================="
