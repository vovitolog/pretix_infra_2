# RabbitMQ Docker Role

This Ansible role deploys RabbitMQ inside a Docker container. It pulls the RabbitMQ image, creates necessary directories, configures environment variables, and runs the container with persistent storage and network settings.

## Requirements

* Ansible 2.15.0 or higher.
* Docker must be pre-installed on the target host.
* Ansible Vault for managing encrypted secrets.
* `community.docker` Ansible collection.

Install the required collection with:

```bash
ansible-galaxy collection install community.docker
```

## Role Variables

Variables are split into two files:

* `defaults/main/main.yml`: Non-sensitive variables (e.g., `image`, `container_name`).
* `defaults/main/secret.yml`: Sensitive variables (e.g., `rabbitmq_password`), encrypted with Ansible Vault.

### Main Variables (`defaults/main/main.yml`)

* `image`: Docker image name (default: `rabbitmq:3.10.7-management`).
* `container_name`: Name of the RabbitMQ container (default: `rabbitmq`).
* `ports`: List of ports to expose (default: `["5672:5672", "15672:15672"]`).
* `env`: Environment variables for RabbitMQ container (default includes user, password, and vhost).
* `data_dir`: Local directory for RabbitMQ data persistence (default: `/var/lib/rabbitmq`).
* `restart_policy`: Docker container restart policy (default: `unless-stopped`).
* `network_name`: Docker network name to attach the container to (default: `pretix-network`).

### Sensitive Variables (`defaults/main/secret.yml`)

* `rabbitmq_password`: Password for the default RabbitMQ user (encrypted with Ansible Vault).

## Playbook

Example playbook to set up RabbitMQ in Docker:

```yaml
# /ansible/playbooks/setup_rabbitmq_docker.yml
- hosts: backend
  become: true
  collections:
    - community.docker
  roles:
    - role: rabbitmq-docker
      vars:
        # By default, variables are correctly set and usually do not require changes.
        # You can override them if necessary:
        # image: "rabbitmq:3.10.7-management"
        # container_name: "rabbitmq"
        # ports:
        #   - "5672:5672"
        #   - "15672:15672"
        # env:
        #   RABBITMQ_DEFAULT_USER: "pretix"
        #   RABBITMQ_DEFAULT_PASS: "{{ rabbitmq_password }}"
        #   RABBITMQ_DEFAULT_VHOST: "pretix_vhost"
        # data_dir: "/var/lib/rabbitmq"
        # restart_policy: "unless-stopped"
        # network_name: "pretix-network"
```

## How to Use

Playbook must be executed from the `/ansible` directory.

1. Run the command:

```bash
ansible-playbook playbooks/setup_rabbitmq_docker.yml -J
```

2. Enter the password for Ansible Vault when prompted.
3. RabbitMQ will be deployed inside a Docker container and ready to use!

## What This Role Does

The role performs the following actions:

1. Verifies Docker API is available on the target host.
2. Creates a local data directory for RabbitMQ.
3. Pulls (or updates) the specified RabbitMQ Docker image.
4. Ensures the specified Docker network exists.
5. Runs the RabbitMQ container with specified configurations (ports, environment, volumes, restart policy).

