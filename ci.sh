#! /bin/bash
set -e

NAMESPACE="default"
BUILD_DIR="/tmp/ci-${RANDOM}"

BUILD_TOOL="sudo nerdctl" # replace with 'docker' locally
REGISTRY_URL="registry.kelog.pl"

build() {
  repo=$1
  image=$2
  pod=$3
  full_image="${REGISTRY_URL}/kelog/${image}:latest" 
  echo "Building repo = ${repo}, full_image = ${full_image}, pod = ${pod}..."

  git clone "https://github.com/AleksanderGrzybowski/${repo}.git"
  cd ${repo}

  ${BUILD_TOOL} build --no-cache -t ${full_image} .
  ${BUILD_TOOL} push ${full_image}
  ${BUILD_TOOL} system prune --force

  kubectl -n ${NAMESPACE} get pods | grep ${pod} | awk '{print $1}' | xargs kubectl -n ${NAMESPACE} delete pod
  cd ..
  echo "Building ${repo} finished."
}

echo "Building in ${BUILD_DIR}."
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

build aleksandergrzybowski.pl aleksandergrzybowski.pl aleksandergrzybowski
build 2048 2048 2048
build csmsearch csmsearch csmsearch

rm -rf ${BUILD_DIR}
