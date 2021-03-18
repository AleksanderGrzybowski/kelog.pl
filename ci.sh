#! /bin/bash
set -e

NAMESPACE="default"
BUILD_DIR="/tmp/ci-${RANDOM}"

build() {
  repo=$1
  image=$2
  pod=$3
  echo "Building repo = ${repo}, image = ${image}, pod = ${pod}..."

  git clone "https://github.com/AleksanderGrzybowski/${repo}.git"
  cd ${repo}
  docker build -t "kelog/${image}:latest" .
  kubectl -n ${NAMESPACE} get pods | grep ${pod} | awk '{print $1}' | xargs kubectl -n ${NAMESPACE} delete pod
  cd ..
  echo "Building ${repo} finished."
}

echo "Building in ${BUILD_DIR}."
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

build aleksandergrzybowski.pl aleksandergrzybowski.pl aleksandergrzybowski
build csmsearch csmsearch csmsearch
build 2048 2048 2048

