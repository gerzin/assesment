#!/bin/bash
# CI script to run all tests using Bazel

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/print_utils.sh"

print_header "Running All Tests"
echo ""

# Run all tests in the workspace
# Bazel will automatically discover and run all tests,
# cache results, and only re-run what changed!
echo "Running all tests..."
bazel test //... --test_output=errors

echo ""
print_success "All tests passed!"
