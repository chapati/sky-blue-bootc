#!/bin/bash
set -euo pipefail

echo "Building local image..."
docker build -t sky-blue -f containerfile . # --progress=plain
