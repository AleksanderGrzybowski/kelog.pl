#!/bin/bash
set -e

REPO_URL="https://github.com/AleksanderGrzybowski/aleksandergrzybowski.pl.git"
TEMP_DIR=$(mktemp -d -t git-clone-XXXXXXXX)
IMAGE_NAME="aleksandergrzybowskipl:latest"
TARGET_HOST_DIR="/var/aleksandergrzybowski.pl"

echo "Cloning ${REPO_URL} to ${TEMP_DIR}"
git clone "${REPO_URL}" "${TEMP_DIR}"

cd "${TEMP_DIR}"

echo "Building Docker image ${IMAGE_NAME}"
docker build -t "${IMAGE_NAME}" .

echo "Attempting to copy /usr/share/nginx/html from container to ${TARGET_HOST_DIR} on host."
docker run --rm -v /var:/hostvar "${IMAGE_NAME}" /bin/bash -c "cp -R /usr/share/nginx/html/* /hostvar/aleksandergrzybowski.pl/"

