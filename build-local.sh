#!/bin/bash
set -euo pipefail

IMAGE_TAG="localhost:5000/sky-blue:latest"

echo "Building local image..."
docker build --build-arg SKIP_DEV_LAYER=false -t "${IMAGE_TAG}" -f containerfile .

echo "Pushing to local host registry..."
docker push "${IMAGE_TAG}"