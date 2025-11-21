#!/usr/bin/env python3
"""
Pytest runner wrapper for Bazel.
This script invokes pytest with the test file.
"""

import sys

import pytest

if __name__ == "__main__":
    # Run pytest with the test file and any additional args
    sys.exit(
        pytest.main([__file__.replace("run_pytest.py", "test_shared_lib.py"), "-v", "--tb=short"])
    )
