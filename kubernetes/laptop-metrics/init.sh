#! /bin/bash
kubectl create secret generic grafana-admin-password --from-literal="password=letmein"
