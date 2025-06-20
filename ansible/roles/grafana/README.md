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
 | `grafana_image` | The Docker image to use for Grafana. | `"grafana/grafana-oss"` |
 | `grafana_container_name` | The name of the Grafana container. | `"grafana"` |
 | `grafana_container_uid` | The user ID under which Grafana runs inside the container. | `"472"` |
 | `grafana_container_restart_policy` | The restart policy for the Grafana container. | `"unless-stopped"` |
 | `grafana_docker_network` | Docker network for Grafana. | `"monitoring_net"` |
 | `grafana_http_port` | HTTP port for Grafana. | `"3000"` |
 | `grafana_domain` | Domain for accessing Grafana. | `"localhost"` |
 | `grafana_provisioning_dir` | Directory path for Grafana provisioning configurations. | `"/opt/grafana/provisioning"` |
 | `provisioning_configs_deploy` | Whether to deploy provisioning configurations. | `false` |
 | `grafana_admin_user` | Grafana admin username. | `"admin"` |
 | `grafana_admin_password` | Grafana admin password. |  |

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
- name: Deploy of Grafana using Docker containers
  hosts: grafana_server
  become: true
  vars:
    grafana_version: "12.0.1-ubuntu"
    grafana_image: "grafana/grafana-oss"

    grafana_container_name: "grafana"
    grafana_container_uid: "472"
    grafana_container_restart_policy: "unless-stopped"

    grafana_docker_network: "monitoring_net"
    grafana_http_port: "3000"
    grafana_domain: "localhost"

    grafana_provisioning_dir: "/opt/grafana/provisioning"
    provisioning_configs_deploy: false

    grafana_admin_user: "admin"
    grafana_admin_password: "admin_qwerty"

  roles:
    - grafana

```

For become: false

```yaml
---
- name: Deploy of Grafana using Docker containers
  hosts: grafana_server
  become: false
  vars:
    grafana_version: "12.0.1-ubuntu"
    grafana_image: "grafana/grafana-oss"

    grafana_container_name: "grafana"
    grafana_container_uid: "472"
    grafana_container_restart_policy: "unless-stopped"

    grafana_docker_network: "monitoring_net"
    grafana_http_port: "3000"
    grafana_domain: "localhost"

    grafana_provisioning_dir: "{{ ansible_user_dir }}/grafana/provisioning"
    provisioning_configs_deploy: false

    grafana_admin_user: "admin"
    grafana_admin_password: "admin_qwerty"

  roles:
    - grafana

```
