#!/bin/bash
set -euo pipefail

IMAGE_TAG="localhost:5000/sky-blue:latest"

DOCKER_BUILDKIT=1 docker build \
  --cpuset-cpus="0-15" \
  --build-arg SKIP_DEV_LAYER=false \
  --build-arg CACHE_KEY=local-dev \
  -t "${IMAGE_TAG}" \
  -f containerfile .

echo "Pushing to local host registry..."
docker push "${IMAGE_TAG}"