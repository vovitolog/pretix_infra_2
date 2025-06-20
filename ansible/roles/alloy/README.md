# Ansible Role: Alloy Configuration and Deployment

This Ansible role is designed to set up and configure Alloy, a time series database, using Docker. It includes tasks to create necessary directories, copy configuration files, and run the Alloy container.

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
 | `alloy_version` | The version of Alloy to deploy. | `"v1.9.1"` |
 | `alloy_path` | The directory path where Alloy will store its data and configuration. | `"/opt/alloy"` |
 | `alloy_docker_network` | Docker network for Alloy. | `"monitoring_net"` |
 | `alloy_volume` | Docker volume for Alloy data. | `"alloy_data"` |
 | `alloy_etc` | Directory path for Alloy configuration files. | `"/opt/alloy/etc"` |
 | `alloy_config_deploy` | Flag to deploy Alloy configuration. | `true` |
 | `alloy_http_port` | HTTP port for Alloy. | `"12345"` |
 | `alloy_container_restart_policy` | Restart policy for the Alloy container. | `"unless-stopped"` |
 | `alloy_loki_hostname` | Hostname for Loki datasource. | `"loki"` |
 | `alloy_loki_http_port` | HTTP port for Loki. | `"3100"` |
 | `alloy_container_uid` | UID for the Alloy container user. | `"473"` |
 | `alloy_container_groups` | List of groups for the Alloy container user. | `["990", "999"]` |

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
- name: Deploy of Alloy using Docker containers
  hosts: all
  become: true
  vars:
    alloy_docker_network: "monitoring_net"
    alloy_volume: "alloy_data"
    alloy_etc: "/opt/alloy/etc"
    alloy_config_deploy: true
    alloy_version: "v1.9.1"
    alloy_http_port: "12345"
    alloy_container_restart_policy: "unless-stopped"
    alloy_loki_hostname: "loki"
    alloy_loki_http_port: "3100"
    alloy_container_uid: "473"
    alloy_container_groups:
      - "990"
      - "999"
  roles:
    - alloy

```

For become: false

```yaml
---
- name: Deploy of Alloy using Docker containers
  hosts: all
  become: false
  vars:
    alloy_docker_network: "monitoring_net"
    alloy_volume: "alloy_data"
    alloy_etc: "{{ ansible_user_dir }}/alloy/etc"
    alloy_config_deploy: true
    alloy_version: "v1.9.1"
    alloy_http_port: "12345"
    alloy_container_restart_policy: "unless-stopped"
    alloy_loki_hostname: "loki"
    alloy_loki_http_port: "3100"
    alloy_container_uid: "473"
    alloy_container_groups:
      - "990"
      - "999"
  roles:
    - alloy

```
