#! /bin/bash

perc=$[100-$(vmstat 1 2|tail -1|awk '{printf "%d", $15}')]
cpu_usage=$(echo $perc | awk '{printf "%2d", $1}')
mem_usage=$(free | grep Mem | awk '{printf "%d", $3/$2 * 100}')

before_download=$(cat /proc/net/dev | grep wlp0 | awk '{print $2}')
before_upload=$(cat /proc/net/dev | grep wlp0 | awk '{print $10}')
sleep 1
after_download=$(cat /proc/net/dev | grep wlp0 | awk '{print $2}')
after_upload=$(cat /proc/net/dev | grep wlp0 | awk '{print $10}')
download=$(echo "$before_download $after_download" | awk '{printf "%2.1f", ($2-$1)/(1024*1024)}')
upload=$(echo "$before_upload $after_upload" | awk '{printf "%2.1f", ($2-$1)/(1024*1024)}')

echo "C: ${cpu_usage}% | M: ${mem_usage}% | N: ${download} / ${upload}"
