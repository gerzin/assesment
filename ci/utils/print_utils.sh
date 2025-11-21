#!/bin/bash
# Utility functions for printing formatted messages in CI scripts

# Print a header message with borders
# Usage: print_header "Your message here"
print_header() {
    local message="$1"
    echo "=========================================="
    echo "$message"
    echo "=========================================="
}

# Print an error header message with borders
# Usage: print_error "Error message here"
print_error() {
    local message="$1"
    echo "=========================================="
    echo "ERROR: $message"
    echo "=========================================="
}

# Print a success header message with borders
# Usage: print_success "Success message here"
print_success() {
    local message="$1"
    echo "=========================================="
    echo "✓ $message"
    echo "=========================================="
}
