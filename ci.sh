#! /bin/bash
set -e

NAMESPACE="default"
BUILD_DIR="/tmp/ci-${RANDOM}"
EFK_COMPONENTS="elasticsearch kibana fluentd"

build() {
  repo=$1
  image=$2
  pod=$3
  echo "Building repo = ${repo}, image = ${image}, pod = ${pod}..."

  git clone "https://github.com/AleksanderGrzybowski/${repo}.git"
  cd ${repo}
  docker build --no-cache -t "kelog/${image}:latest" .
  kubectl -n ${NAMESPACE} get pods | grep ${pod} | awk '{print $1}' | xargs kubectl -n ${NAMESPACE} delete pod
  cd ..
  echo "Building ${repo} finished."
}

for component in $EFK_COMPONENTS; do
    kubectl -n efk scale deployment $component --replicas=0
done

echo "Building in ${BUILD_DIR}."
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

build aleksandergrzybowski.pl aleksandergrzybowski.pl aleksandergrzybowski
build 2048 2048 2048
build csmsearch csmsearch csmsearch

docker system prune --force

for component in $EFK_COMPONENTS; do
    kubectl -n efk scale deployment $component --replicas=1
done
