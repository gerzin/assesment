#!/usr/bin/env python3
"""Generic pytest runner for Bazel py_test targets."""

if __name__ == "__main__":
    import sys

    import pytest

    sys.exit(pytest.main(sys.argv[1:]))
