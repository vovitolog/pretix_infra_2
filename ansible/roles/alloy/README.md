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
 | `alloy_docker_network` | Docker network for Alloy. | `"alloy-net"` |
 | `alloy_http_port` | HTTP port for Alloy. | `"12345"` |
 | `loki_hostname` | Hostname for Loki datasource. | `"loki"` |
 | `loki_http_port` | HTTP port for Loki. | `"3100"` |

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
- name: Deploy of Alloy using Docker containers
  hosts: all
  become: true
  vars:
    alloy_version: "v1.9.1"
    alloy_path: "/opt/alloy"
    alloy_docker_network: "alloy-net"
    alloy_http_port: "12345"
    loki_hostname: loki
    loki_http_port: "3100"
  roles:
    - alloy

```
