# Python Testing with pytest

The Python tests for ground_control use **pytest** instead of unittest for a more modern and feature-rich testing experience.

## Why pytest?

- **Simple syntax**: Use plain `assert` statements instead of `self.assertEqual()`
- **Better output**: Detailed assertion introspection shows exactly what failed
- **Fixtures**: Powerful dependency injection system for test setup
- **Markers**: Organize and selectively run tests with `@pytest.mark.*`
- **Plugins**: Rich ecosystem of pytest plugins
- **Parametrization**: Easy to write data-driven tests

## Test Structure

```
ground_control/
├── pytest.ini          # Pytest configuration
├── tests/
│   ├── __init__.py
│   ├── conftest.py     # Shared fixtures
│   ├── run_pytest.py   # Bazel pytest runner wrapper
│   └── test_*.py       # Test files
```

## Running Tests

### With Bazel (recommended)

```bash
# Run all tests
bazel test //...

# Run only Python tests
bazel test //ground_control/tests:...

# Run with detailed output
bazel test //ground_control/tests:test_shared_lib --test_output=streamed

# Run specific test
bazel test //ground_control/tests:test_shared_lib --test_filter=test_valid_command_simple
```

### Locally with uv

```bash
cd ground_control
uv run pytest tests/ -v
```

## Writing Tests

### Basic Test

```python
def test_example(onboard):
    """Test description."""
    result = onboard.process_command("POWER_ON")

    assert result["success"] is True
    assert result["response"] == "ACK: POWER_ON"
```

### Using Fixtures

Fixtures are defined in `conftest.py`:

```python
@pytest.fixture
def onboard():
    """Provides an OnboardLib instance for tests."""
    return OnboardLib()
```

Use them by adding the fixture name as a parameter:

```python
def test_with_fixture(onboard):
    # onboard is automatically injected
    result = onboard.process_command("TEST")
    assert result is not None
```

### Test Markers

Mark tests to organize them:

```python
@pytest.mark.unit
def test_unit():
    """Fast unit test."""
    pass

@pytest.mark.integration
def test_integration(onboard):
    """Integration test with C++ library."""
    pass
```

Run specific markers:

```bash
uv run pytest tests/ -m unit        # Only unit tests
uv run pytest tests/ -m integration  # Only integration tests
```

### Parametrized Tests

Test multiple inputs easily:

```python
@pytest.mark.parametrize("command,expected", [
    ("POWER_ON", "ACK: POWER_ON"),
    ("POWER_OFF", "ACK: POWER_OFF"),
    ("GET_STATUS", "ACK: GET_STATUS"),
])
def test_commands(onboard, command, expected):
    result = onboard.process_command(command)
    assert result["response"] == expected
```

### Exception Testing

```python
def test_exception():
    with pytest.raises(FileNotFoundError):
        OnboardLib(lib_path="/nonexistent/path")
```

## Configuration

### pytest.ini

```ini
[pytest]
# Test discovery
python_files = test_*.py
python_classes = Test*
python_functions = test_*

# Output options
addopts =
    -v              # Verbose
    --tb=short      # Short traceback format
    --strict-markers # Error on unknown markers

# Test paths
testpaths = tests

# Custom markers
markers =
    unit: Unit tests
    integration: Integration tests with C++ library
```

### conftest.py

Shared fixtures and configuration:

```python
import pytest
from ground_control.onboard import OnboardLib

@pytest.fixture(scope="session")
def onboard_session():
    """Session-scoped fixture - created once per test session."""
    return OnboardLib()

@pytest.fixture(scope="module")
def onboard():
    """Module-scoped fixture - created once per test module."""
    return OnboardLib()

@pytest.fixture
def onboard_instance():
    """Function-scoped fixture - created for each test."""
    return OnboardLib()
```

## Bazel Integration

The tests use a wrapper script (`run_pytest.py`) to invoke pytest from Bazel:

```python
#!/usr/bin/env python3
import sys
import pytest

if __name__ == "__main__":
    sys.exit(pytest.main([__file__.replace("run_pytest.py", "test_shared_lib.py"), "-v", "--tb=short"]))
```

BUILD.bazel configuration:

```starlark
py_test(
    name = "test_shared_lib",
    srcs = [
        "conftest.py",
        "run_pytest.py",
        "test_shared_lib.py",
    ],
    data = [
        "//ground_control:pytest.ini",
        "//onboard:libonboard.so",
    ],
    main = "run_pytest.py",
    deps = [
        "//ground_control:onboard_client",
        "@pypi//pytest",
    ],
)
```

## Migration from unittest

### Before (unittest)

```python
import unittest

class TestOnboardLib(unittest.TestCase):
    def setUp(self):
        self.onboard = OnboardLib()

    def test_command(self):
        result = self.onboard.process_command("TEST")
        self.assertTrue(result["success"])
        self.assertEqual(result["response"], "ACK: TEST")

if __name__ == "__main__":
    unittest.main()
```

### After (pytest)

```python
import pytest

@pytest.fixture
def onboard():
    return OnboardLib()

def test_command(onboard):
    result = onboard.process_command("TEST")
    assert result["success"] is True
    assert result["response"] == "ACK: TEST"
```

## Tips

1. **Use descriptive test names**: `test_valid_command_with_spaces` is better than `test1`
2. **One assert per test**: Makes failures easier to debug
3. **Use fixtures for setup**: Avoid repeated setup code
4. **Mark your tests**: Use markers to organize integration vs unit tests
5. **Test edge cases**: Empty strings, None values, boundary conditions
6. **Use parametrize**: Test multiple inputs without code duplication

## Resources

- [pytest documentation](https://docs.pytest.org/)
- [pytest fixtures](https://docs.pytest.org/en/stable/fixture.html)
- [pytest markers](https://docs.pytest.org/en/stable/mark.html)
- [pytest parametrize](https://docs.pytest.org/en/stable/parametrize.html)
