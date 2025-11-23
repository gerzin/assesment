# Onboard Communication System

A C++23 onboard communication module with Python ground control integration. The project uses Bazel, pros and cons of the decisions will be discussed in the interview for lack of time on my side to dedicate to the assignment.


## Quick Start

The onboard is a just a dummy C++ module that returns an "ACK: <message>" if the message contained only alphanumeric characters, an error otherwise.

### Using Docker

The easiest way to build and test the code is using Docker, so you won't have to install bazel(isk) and other dependencies that you might not have installed.

```bash
docker build -t onboard-system -f docker/Dockerfile .

docker run -it onboard-system bash

# Inside the container, you can run:
bazel build //...                    # Build all targets
bazel test //...                     # Run all tests
./ci/run_ci.sh                       # Run full CI pipeline
bazel run //onboard:onboard_app -- CMD_123 # To run the C++ app
bazel run //ground_control:ground_control -- --message 'test@invalid!' # To run the python ground control module
```

Or run commands directly:

```bash
# Build everything
docker run --rm onboard-system bazel build //...

# Run tests
docker run --rm onboard-system bazel test //...

...
```

### Local Build (Without Docker)

If you have all prerequisites installed locally you can basically run the same commands that are run in the docker file.

```bash
# Build all targets
bazel build //...

# Run C++ tests
bazel test //onboard/tests:onboard_test

# Run Python tests
bazel test //ground_control/tests:test_shared_lib
```
