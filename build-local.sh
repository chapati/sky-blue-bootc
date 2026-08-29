#!/bin/bash
set -euo pipefail

# Dev defaults
IMAGE_NAME="sky-blue-nvidia-open"
IMAGE_FLAVOR="nvidia-open"
IMAGE_VENDOR="local-dev"
IMAGE_TAG="latest"
BASE_IMAGE_NAME="bluefin-nvidia-open"
LOCAL_REGISTRY_TAG="localhost:5000/${IMAGE_NAME}:${IMAGE_TAG}"

docker build \
  --cpuset-cpus="0-15" \
  --push \
  --build-arg SKIP_DEV_LAYER=false \
  --build-arg IMAGE_NAME="${IMAGE_NAME}" \
  --build-arg IMAGE_FLAVOR="${IMAGE_FLAVOR}" \
  --build-arg IMAGE_VENDOR="${IMAGE_VENDOR}" \
  --build-arg IMAGE_TAG="${IMAGE_TAG}" \
  --build-arg BASE_IMAGE_NAME="${BASE_IMAGE_NAME}" \
  -t "${LOCAL_REGISTRY_TAG}" \
  -f containerfile .
