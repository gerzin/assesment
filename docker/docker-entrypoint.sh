#!/bin/bash

# If no arguments provided, show help and start interactive shell
if [ $# -eq 0 ]; then
    cat << 'EOF'
Onboard Communication System Docker Environment

Available commands:
  bazel build //...           - Build all targets
  bazel test //...            - Run all tests
  bazel run //onboard:onboard_app -- CMD_123
  bazel run //ground_control:ground_control -- CMD_456
  ./ci/run_ci.sh              - Run full CI pipeline
  ./ci/run_tests.sh           - Run all tests
  ./ci/format_cpp.sh          - Format C++ code
  ./ci/format_python.sh       - Format Python code

Start an interactive shell with:
  docker run -it <image_name> bash
EOF
    exec bash
else
    # Execute the provided command
    exec "$@"
fi
