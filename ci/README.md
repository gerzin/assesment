# CI Scripts

This directory contains continuous integration scripts for the project.

## Scripts

### Main CI Pipeline

- **`run_ci.sh`** - Main CI script that runs all checks in sequence
  - C++ formatting check
  - Python formatting check  
  - Build all targets
  - Run all tests

### Individual Checks

- **`check_cpp_format.sh`** - Check C++ code formatting with clang-format
- **`check_python_format.sh`** - Check Python code formatting with ruff
- **`run_tests.sh`** - Run all tests (C++ and Python)

### Formatting Tools

- **`format_cpp.sh`** - Auto-format C++ code with clang-format
- **`format_python.sh`** - Auto-format Python code with ruff

## Usage

### Run Complete CI Pipeline

```bash
./ci/run_ci.sh
```

### Run Individual Checks

```bash
# Check C++ formatting
./ci/check_cpp_format.sh

# Check Python formatting
./ci/check_python_format.sh

# Run tests only
./ci/run_tests.sh
```

### Auto-Format Code

```bash
# Format C++ code
./ci/format_cpp.sh

# Format Python code
./ci/format_python.sh
```

## GitHub Actions

The CI pipeline is automated via GitHub Actions (`.github/workflows/ci.yml`).

**Triggers:**
- Push to `main`, `develop`, or `module/*`, `feature/*` branches
- Pull requests to `main` or `develop`

**Steps:**
1. Checkout code
2. Set up Bazel with caching
3. Install dependencies (clang-format, ruff)
4. Check C++ formatting
5. Check Python formatting
6. Build all targets
7. Run all tests

## Requirements

### C++ Formatting
- `clang-format` (install: `sudo apt-get install clang-format`)

### Python Formatting
- `ruff` (install: `pip install ruff` or use `uv`)

### Build & Test
- Bazel (managed via bazelisk)
- Python 3.13
- GCC with C++23 support

## Bazel Benefits for CI

✅ **Caching**: Bazel caches test results and only rebuilds changed targets  
✅ **Incremental**: Only affected tests are re-run  
✅ **Reproducible**: Hermetic builds ensure consistency  
✅ **Fast**: Parallel execution of tests and builds  

## Local Development

Before pushing code, run the full CI pipeline locally:

```bash
./ci/run_ci.sh
```

This ensures your changes will pass CI checks on GitHub Actions.
