# Ansible K3S Playbook

Playbook for creating K3S, Load balancer and proxy infrastructure on Oracle.

# Usage:
See inventory/hosts.example to check on how to setup your inventory, then set a POSTGRES_PASSWORD env var to setup PostgresSQL on the VMs. You may also need to use extra vars named domains to load your domain names and create the certificate.

# Roles
## mommon
Common configuration for machines that will run k3s as node or control plane

## master
Tasks to setup a control plane for K3S. It need to have a "POSTGRES_PASSWORD" setup if you plan on installing PostgresSQL on Docker.

## worker
Tasks to setup a worker for K3S

## lb
Tasks to setup load balancer, it uses the extra var domains to create your let's encrypt certificate.
