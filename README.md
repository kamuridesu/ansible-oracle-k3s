# Ansible K3S Playbook

Playbook for creating K3S, Load balancer and proxy infrastructure on Oracle.

# Usage:
See inventory/hosts.example to check on how to setup your inventory

# Roles
## mommon
Common configuration for machines that will run k3s as node or control plane

## master
Tasks to setup a control plane for K3S. It need to have a "POSTGRES_PASSWORD" setup if you plan on installing PostgresSQL on Docker.

## worker
Tasks to setup a worker for K3S

## proxy
Tasks to setup a proxy on Oracle. It needs to have two environment variables set: DANTE_USER and DANTE_PASSWORD

## lb
Tasks to setup load balancer