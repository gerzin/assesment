#!/usr/bin/env bash
set -euo pipefail

echo "Running coverage analysis..."

# Run tests with coverage instrumentation
bazel coverage //... \
    --combined_report=lcov \
    --instrument_test_targets

# Check if coverage data was generated
if [ -d "bazel-out/_coverage" ]; then
    echo "Coverage analysis completed successfully"

    # Display coverage summary if available
    if [ -f "bazel-out/_coverage/_coverage_report.dat" ]; then
        echo ""
        echo "Coverage report generated: bazel-out/_coverage/_coverage_report.dat"
    fi

    # Count gcov files
    gcov_count=$(find bazel-out/_coverage -name "*.gcov" 2>/dev/null | wc -l)
    echo "Generated $gcov_count .gcov files"
else
    echo "Warning: Coverage data directory not found"
    exit 1
fi
