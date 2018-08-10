#! /bin/bash
kubectl create secret generic laptop-metrics-grafana-admin-password --from-literal="password=letmein"
