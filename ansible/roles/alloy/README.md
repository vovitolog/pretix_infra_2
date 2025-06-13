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

- `alloy_version`: The version of Alloy to deploy. Default is `"v1.9.1 "`.
- `grafana_path`: The directory path where Alloy will store its data and configuration. Default is `"/opt/alloy"`.
- `loki_hostname`: Hostname for Loki datasource. Default is `"loki"`.

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
    loki_hostname: loki

  roles:
    - alloy

```
