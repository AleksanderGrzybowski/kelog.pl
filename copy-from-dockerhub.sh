#! /bin/bash
set -e

source="$1"
destination="registry.kelog.pl/${source}"

docker pull ${source}
docker tag ${source} ${destination}
docker push ${destination}
