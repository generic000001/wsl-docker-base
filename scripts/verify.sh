#!/usr/bin/env bash

set -euo pipefail

echo "Checking Docker installation..."
docker --version

echo
echo "Running Docker test container..."
docker run --rm hello-world
