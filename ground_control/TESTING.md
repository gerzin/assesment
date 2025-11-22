# Python Testing with pytest

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
