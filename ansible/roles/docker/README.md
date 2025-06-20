# Ansible Role: Docker Installation

This Ansible role automates the installation of Docker on Ubuntu 24.04 systems. It ensures that Docker is installed, configured, and running on the target machines.

## Requirements

- Ansible 2.15 or higher
- Target machines running Ubuntu 24.04
- SSH access to the target machines
- Sudo privileges on the target machines

## Role Variables

The role defines several variables that can be overridden to customize the installation process. These variables are defined in `defaults/main.yml`:
   Variable | Description | Default Values |
 |---------|-------------|----------------|
 | `apt_https_packages` | List of packages required to allow apt to use a repository over HTTPS. | ```yaml<br>- apt-transport-https<br>- ca-certificates<br>- curl<br>- software-properties-common<br>- gnupg-agent<br>``` |
 | `docker_packages` | List of Docker packages to install. | ```yaml<br>- docker-ce<br>- docker-ce-cli<br>- containerd.io<br>- docker-compose-plugin<br>``` |

## Dependencies

This role does not have any external dependencies.

## Example Playbook

To use this role, create a playbook that includes the role. Here is an example playbook:

```yaml
---
- name: Install Docker on Ubuntu 24.04
  hosts: servers
  become: true
  roles:
    - docker
```
