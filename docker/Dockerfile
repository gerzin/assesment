FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    clang-format \
    curl \
    git \
    gnupg \
    python3 \
    python3-venv \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Bazelisk
RUN wget -O /usr/local/bin/bazel https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 \
    && chmod +x /usr/local/bin/bazel

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    /root/.local/bin/uv tool install ruff && \
    /root/.local/bin/uv tool install pre-commit

ENV PATH="/root/.local/bin:${PATH}"

RUN wget -O /usr/local/bin/buildifier https://github.com/bazelbuild/buildtools/releases/latest/download/buildifier-linux-amd64 \
    && chmod +x /usr/local/bin/buildifier

WORKDIR /workspace

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY . /workspace

RUN git config --global user.email "docker@example.com" \
    && git config --global user.name "Docker User" \
    && git config --global --add safe.directory /workspace

# Pre-fetch Bazel dependencies to speed up first build
RUN bazel fetch //... || true

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
