#!/bin/bash
set -euo pipefail

IMAGE_TAG="localhost:5000/sky-blue:latest"

docker build \
  --cpuset-cpus="0-15" \
  --push \
  --build-arg SKIP_DEV_LAYER=false \
  --build-arg CACHE_KEY=local-dev \
  -t "${IMAGE_TAG}" \
  -f containerfile .

echo "Pushing to local host registry..."
docker push "${IMAGE_TAG}"
