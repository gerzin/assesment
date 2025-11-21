#!/bin/bash
# Script to collect build artifacts locally

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARTIFACTS_DIR="$PROJECT_ROOT/artifacts"

# Source utility functions
source "$SCRIPT_DIR/utils/print_utils.sh"

cd "$PROJECT_ROOT"

print_header "Collecting Build Artifacts"
echo ""

# Clean previous artifacts
rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR/executables"
mkdir -p "$ARTIFACTS_DIR/test-logs"
mkdir -p "$ARTIFACTS_DIR/coverage"

# Build executables
echo "Building executables..."
bazel build //onboard:onboard_app
bazel build //onboard:libonboard.so

# Copy executables
echo "Collecting executables..."
cp -L bazel-bin/onboard/onboard_app "$ARTIFACTS_DIR/executables/" || true
cp -L bazel-bin/onboard/libonboard.so "$ARTIFACTS_DIR/executables/" || true

# Run coverage analysis
echo ""
echo "Running coverage analysis..."
./ci/run_coverage.sh || echo "Warning: Coverage collection had issues"

# Collect test logs
echo ""
echo "Collecting test logs..."
find bazel-testlogs -name "test.log" -exec cp --parents {} "$ARTIFACTS_DIR/test-logs/" \; 2>/dev/null || true
find bazel-testlogs -name "test.xml" -exec cp --parents {} "$ARTIFACTS_DIR/test-logs/" \; 2>/dev/null || true

# Collect coverage reports
echo "Collecting coverage reports..."
if [ -f bazel-out/_coverage/_coverage_report.dat ]; then
  cp bazel-out/_coverage/_coverage_report.dat "$ARTIFACTS_DIR/coverage/" || true
fi
if [ -d bazel-out/_coverage ]; then
  find bazel-out/_coverage -name "*.gcov" -exec cp --parents {} "$ARTIFACTS_DIR/coverage/" \; 2>/dev/null || true
  find bazel-out/_coverage -name "*.dat" -exec cp --parents {} "$ARTIFACTS_DIR/coverage/" \; 2>/dev/null || true
fi

# Create build info
cat > "$ARTIFACTS_DIR/build-info.txt" <<EOF
Build Date: $(date)
Git Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')
Git Commit: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')
Git Short Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')
Build Host: $(hostname)
Build User: $(whoami)
EOF

# Create summary
echo ""
print_success "Artifacts collected in: $ARTIFACTS_DIR"
echo ""
echo "Contents:"
echo "  Executables: $(find "$ARTIFACTS_DIR/executables" -type f | wc -l) files"
echo "  Test logs: $(find "$ARTIFACTS_DIR/test-logs" -type f | wc -l) files"
echo "  Coverage: $(find "$ARTIFACTS_DIR/coverage" -type f | wc -l) files"
echo ""
echo "To view:"
echo "  ls -R $ARTIFACTS_DIR"
echo ""
