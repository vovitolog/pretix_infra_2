# Ansible Role: Grafana Deployment

This Ansible role automates the deployment of Grafana using Docker containers.

## Requirements

- Ansible 2.15 or higher
- Target machines running Ubuntu 24.04
- Target machines with Docker installed
- SSH access to the target machines
- Sudo privileges on the target machines

## Role Variables

The role defines several variables that can be overridden to customize the deployment process. These variables are defined in `defaults/main.yml`:

- `grafana_version`: The version of Grafana to deploy. Default is `"12.0.1-ubuntu"`.
- `grafana_path`: The directory path where Grafana will store its data and configuration. Default is `"/opt/grafana"`.
- `loki_hostname`: Hostname for Loki datasource. Default is `"loki"`.
- `prometheus_hostname`: Hostname for Prometheus datasource. Default is `"prometheus"`.
- `grafana_admin_user`: Grafana admin username. Default is not set.
- `grafana_admin_password`: Grafana admin password. Default is not set.

## Dependencies

This role assumes that Docker is already installed on the target system. You can use the `docker` role to ensure Docker is installed:

```yaml
- name: Ensure Docker is installed
  include_role:
    name: docker
```

## Example Playbook

To use this role, create a playbook that includes the role. Here is an example playbook:

```yaml
---
- name: Deploy of Grafana using Docker containers
  hosts: grafana-server
  become: true
  vars:
    grafana_version: "12.0.1-ubuntu"
    grafana_path: "/opt/grafana"
    loki_hostname: loki
    prometheus_hostname: prometheus
    grafana_admin_user: admin
    grafana_admin_password: admin

  roles:
    - grafana

```
