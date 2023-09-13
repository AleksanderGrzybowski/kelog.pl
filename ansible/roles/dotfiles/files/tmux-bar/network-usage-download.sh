#! /bin/bash

before=$(cat /proc/net/dev | grep wlp0 | awk '{print $2}')
sleep 1
after=$(cat /proc/net/dev | grep wlp0 | awk '{print $2}')

echo "$before $after" | awk '{printf "%2.1f", ($2-$1)/(1024*1024)}'
