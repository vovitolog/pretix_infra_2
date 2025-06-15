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
   Variable | Description | Default Value |
 |----------|-------------|---------------|
 | `grafana_version` | The version of Grafana to deploy. | `"12.0.1-ubuntu"` |
 | `grafana_path` | The directory path where Grafana will store its data and configuration. | `"/opt/grafana"` |
 | `grafana_http_port` | HTTP port for Grafana. | `"3000"` |
 | `grafana_docker_network` | Docker network for Grafana. | `"grafana-net"` |
 | `grafana_admin_user` | Grafana admin username. | `"admin"` |
 | `loki_hostname` | Hostname for Loki datasource. | `"loki"` |
 | `loki_http_port` | HTTP port for Loki. | `"3100"` |
 | `prometheus_hostname` | Hostname for Prometheus datasource. | `"prometheus"` |
 | `prometheus_http_port` | HTTP port for Prometheus. | `"9090"` |

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
  hosts: grafana_server
  become: true
  vars:
    grafana_version: 12.0.1-ubuntu
    grafana_path: /opt/grafana
    grafana_http_port: "3000"
    grafana_docker_network: "grafana-net"
    grafana_admin_user: "admin"
    loki_hostname: loki
    loki_http_port: "3100"
    prometheus_hostname: prometheus
    prometheus_http_port: "9090"
  roles:
    - grafana

```
