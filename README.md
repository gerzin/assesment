# Onboard Communication System

A C++23 onboard communication module with Python ground control integration.


## Quick Start

### Using Docker

The easiest way to build and test the code is using Docker:

```bash
docker build -t onboard-system -f docker/Dockerfile .

docker run -it onboard-system bash

# Inside the container, you can run:
bazel build //...                    # Build all targets
bazel test //...                     # Run all tests
./ci/run_ci.sh                       # Run full CI pipeline
bazel run //onboard:onboard_app -- CMD_123
```

Or run commands directly:

```bash
# Build everything
docker run --rm onboard-system bazel build //...

# Run tests
docker run --rm onboard-system bazel test //...

# Run CI pipeline
docker run --rm onboard-system ./ci/run_ci.sh
```

### Local Build (Without Docker)

If you have all prerequisites installed locally:

```bash
# Build all targets
bazel build //...

# Run C++ tests
bazel test //onboard/tests:onboard_test

# Run Python tests
bazel test //ground_control/tests:test_shared_lib
```
