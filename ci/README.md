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
- **`check_bazel_format.sh`** - Check Bazel file formatting with buildifier
- **`run_tests.sh`** - Run all tests using `bazel test //...`
  - Automatically discovers all test targets
  - Only re-runs tests affected by changes (Bazel caching)
  - Runs tests in parallel for speed
- **`run_coverage.sh`** - Run coverage analysis with instrumentation
  - Generates combined lcov coverage report
  - Creates individual .gcov files
- **`collect_artifacts.sh`** - Collect build artifacts locally
  - Builds executables
  - Runs tests with coverage
  - Collects test logs and coverage reports
  - Creates build info summary

### Formatting Tools

- **`format_cpp.sh`** - Auto-format C++ code with clang-format
- **`format_python.sh`** - Auto-format Python code with ruff
- **`format_bazel.sh`** - Auto-format Bazel files with buildifier

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

# Check Bazel formatting
./ci/check_bazel_format.sh

# Run all tests
./ci/run_tests.sh

# Run coverage analysis
./ci/run_coverage.sh

# Collect artifacts locally
./ci/collect_artifacts.sh
```

### Auto-Format Code

```bash
# Format C++ code
./ci/format_cpp.sh

# Format Python code
./ci/format_python.sh

# Format Bazel files
./ci/format_bazel.sh
```

## GitHub Actions

The CI pipeline is automated via GitHub Actions (`.github/workflows/ci.yml`).

**Triggers:**
- Push to `main`, `develop`, or `module/*`, `feature/*` branches
- Pull requests to `main` or `develop`

**Steps:**
1. Checkout code
2. Set up Bazel with caching
3. Install dependencies (clang-format, ruff, buildifier)
4. Check C++ formatting
5. Check Python formatting
6. Check Bazel formatting
7. Build and test all targets
8. Build executables (onboard_app, libonboard.so)
9. Run coverage analysis with `./ci/run_coverage.sh`
10. Collect and upload artifacts:
    - Executables
    - Test logs (test.log, test.xml)
    - Coverage reports
    - Build information

## Requirements

### C++ Formatting
- `clang-format` (install: `sudo apt-get install clang-format`)

### Python Formatting
- `ruff` (install: `pip install ruff` or use `uv`)

### Bazel Formatting
- `buildifier` (install: `go install github.com/bazelbuild/buildtools/buildifier@latest` or download from [releases](https://github.com/bazelbuild/buildtools/releases))

### Build & Test
- Bazel (managed via bazelisk)
- Python 3.13
- GCC with C++23 support

## Bazel Benefits for CI

✅ **Caching**: Bazel caches test results and only rebuilds changed targets
✅ **Incremental**: Only affected tests are re-run
✅ **Reproducible**: Hermetic builds ensure consistency
✅ **Fast**: Parallel execution of tests and builds
✅ **Automatic Discovery**: No need to hardcode test paths - `bazel test //...` finds all tests

## Build Artifacts

The CI pipeline collects and stores build artifacts for inspection:

### Artifacts Collected

1. **Executables** (retention: 30 days)
   - `onboard_app` - C++ CLI application
   - `libonboard.so` - Shared library

2. **Test Logs** (retention: 30 days)
   - `test.log` - Detailed test output
   - `test.xml` - JUnit format test results

3. **Coverage Reports** (retention: 30 days)
   - `_coverage_report.dat` - Combined coverage data
   - Individual `.gcov` files

4. **Build Information**
   - Build date and time
   - Git branch and commit SHA
   - Workflow run number

### Accessing Artifacts

**In GitHub Actions:**
- Navigate to the workflow run
- Scroll to "Artifacts" section at the bottom
- Download desired artifact zip files

**Locally:**
```bash
./ci/collect_artifacts.sh
ls -R artifacts/
```

Artifacts are stored in `artifacts/` directory:
```
artifacts/
├── executables/
│   ├── onboard_app
│   └── libonboard.so
├── test-logs/
│   └── bazel-testlogs/
│       ├── onboard/tests/onboard_test/test.log
│       └── ground_control/tests/test_shared_lib/test.log
├── coverage/
│   └── bazel-out/_coverage/
└── build-info.txt
```

## Pre-commit Hooks**Recommended:** Install pre-commit hooks to automatically check formatting before committing:

```bash
# Install pre-commit
pip install pre-commit

# Install the git hooks
pre-commit install

# (Optional) Run on all files manually
pre-commit run --all-files
```

Once installed, the hooks will automatically run on staged files when you commit. This catches formatting issues before they reach CI.

### What Gets Checked

- **C++ files**: Formatted with clang-format
- **Python files**: Formatted and linted with ruff
- **Bazel files**: Formatted with buildifier
- **General**: Trailing whitespace, end-of-file, YAML syntax, merge conflicts

## Local Development

Before pushing code, you can either:

**Option 1 (Recommended):** Use pre-commit hooks (see above)

**Option 2:** Run the full CI pipeline manually:

```bash
./ci/run_ci.sh
```

This ensures your changes will pass CI checks on GitHub Actions.
