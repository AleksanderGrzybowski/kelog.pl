#! /bin/bash
set -e

docker stack deploy -c 2048.yml 2048
docker stack deploy -c aleksandergrzybowski.pl.yml aleksandergrzybowskipl
docker stack deploy -c chat.yml chat
docker stack deploy -c facerec.yml facerec
docker stack deploy -c smsalerts.yml smsalerts
docker stack deploy -c jazzstandards.yml jazzstandards
