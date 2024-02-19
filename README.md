# kelog.pl server configuration

## What is this?

This repository contains all configurations for my server and my devices, written in IaC fashion.

## What is inside?

* Ansible playbooks for configuring basic tools (like vim, zsh, k9s) on my machines
* Ansible roles for SSH tunnels and VPNs for remote access
* Kuberentes resource definitions for supporting tools (Prometheus, Grafana) and all my demos from this GitHub
* `_archive` folder with configs no longer used (like Docker Swarm, Icinga2 etc.)

## Why this exists?

I like Infrastructure as Code and Configuration as Code approaches, because they essentially prove that servers and services I use are configured the way I documented it. Also, this is the main demo project that shows my skills in Ansible and Kubernetes :)
