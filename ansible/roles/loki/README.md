# Ansible Role: Loki Deployment

This Ansible role automates the deployment of Grafana Loki using Docker containers.

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
 | `loki_version` | The version of Loki to deploy. | `"3.5.1"` |
 | `loki_path` | The directory path where Loki will store its data and configuration. | `"/opt/loki"` |
 | `loki_http_port` | HTTP port for Loki. | `"3100"` |
 | `loki_docker_network` | Docker network for Loki. | `"loki-net"` |

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
- name: Deploy of Grafana Loki using Docker containers
  hosts: loki_server
  become: true
  vars:
    loki_version: "3.5.1"
    loki_path: "/opt/loki"
    loki_http_port: "3100"
    loki_docker_network: "loki-net"
  roles:
    - loki

```
