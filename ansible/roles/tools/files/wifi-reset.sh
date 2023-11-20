#! /bin/bash
set -e
sleep 1
nmcli radio wifi off 
sleep 2 
nmcli radio wifi on
