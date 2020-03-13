#! /bin/bash
DIR="secrets-$(date +%s)"
mkdir -p ${DIR}

for namespace in default prometheus; do
    for secret in $(kubectl get secrets -n ${namespace} | grep -v controller | grep -v NAME | grep -v token | awk '{print $1}' ); do
        echo "Backing up secret ${secret}..."
        kubectl get secret -n ${namespace} ${secret} -oyaml > "${DIR}/${namespace}-${secret}.yaml"
    done
done
