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
 | `loki_image` | Docker image for Loki | `"grafana/loki"` |
 | `loki_version` | Version of Loki to deploy | `"3.5.1"` |
 | `loki_docker_network` | Docker network for Loki | `"monitoring_net"` |
 | `loki_volume` | Docker volume name for Loki data | `"loki_data"` |
 | `loki_etc` | Path to Loki configuration directory | `"/opt/loki/etc"` |
 | `loki_config_deploy` | Whether to deploy Loki configuration | `true` |
 | `loki_http_port` | HTTP port for Loki | `"3100"` |
 | `loki_container_restart_policy` | Container restart policy | `"unless-stopped"` |
 | `loki_container_uid` | UID for the Loki container | `"10001"` |

## Dependencies

This role assumes that Docker is already installed on the target system. You can use the `docker` role to ensure Docker is installed:

```yaml
- name: Ensure Docker is installed
  include_role:
    name: docker
```

## Example Playbook

To use this role, create a playbook that includes the role. Here is an example playbook:

For become: true

```yaml
---
- name: Deploy of Grafana Loki using Docker containers
  hosts: loki_server
  become: true
  vars:
    loki_image: "grafana/loki"
    loki_version: "3.5.1"
    loki_docker_network: "monitoring_net"
    loki_volume: "loki_data"
    loki_etc: "/opt/loki/etc"
    loki_config_deploy: true
    loki_http_port: "3100"
    loki_container_restart_policy: "unless-stopped"
    loki_container_uid: "10001"
  roles:
    - loki
```

For become: false

```yaml
---
- name: Deploy of Grafana Loki using Docker containers
  hosts: loki_server
  become: false
  vars:
    loki_image: "grafana/loki"
    loki_version: "3.5.1"
    loki_docker_network: "monitoring_net"
    loki_volume: "loki_data"
    loki_etc: "{{ ansible_user_dir }}/loki/etc"
    loki_config_deploy: true
    loki_http_port: "3100"
    loki_container_restart_policy: "unless-stopped"
    loki_container_uid: "10001"
  roles:
    - loki
```
