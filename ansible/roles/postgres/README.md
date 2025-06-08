# Postgres Role

This Ansible role deploys PostgreSQL in a Docker container on the backend server. It configures a secure PostgreSQL instance with persistent storage, suitable for production use alongside other backend services (e.g., Redis, RabbitMQ).

## Requirements

- Ansible 2.9 or higher.
- Debian (Ubuntu) -based system.
- Ansible Vault for managing encrypted secrets.
- Docker.io or Docker-Compose

## Role Variables

Variables are split into two files in `defaults/main/`:
- `main.yml`: Non-sensitive variables (e.g., `postgres_version`, `postgres_port`).
- `secrets.yml`: Sensitive variables (e.g., `postgres_password`), encrypted with Ansible Vault.

## Playbook
Already configured playbook, which is in the directory with playbooks:
```yml!
# /ansible/playbooks/setup_postgresql.yml
- hosts: mvp
  roles:
    - role: postgres
      vars:
        # By default, all variables are set correctly and do not require changes. You can change them if necessary
        # postgres_version: "17.5-alpine"
        # postgres_password: "***"
        # postgres_db: "pretix"
        # postgres_user: "pretix"
        # postgres_ip_port: "127.0.0.1:5432"
        # postgres_volume_name: "postgres_data" 
        # docker_registry_token_name: "GitLab Registry"
        # docker_registry_token: "***"
        # container_network: "pretix-network"
        # gitlab_registry: "gitlab.pretix.devops-factory.com:5050"
        # gitlab_registry_location: "/pretix/pretix-ci-cd"
```

## How to use

Install the required collection with:
```bash
ansible-galaxy collection install community.docker
```

Playbook must be used from the directory `/ansible`

1. Run the command:
```bash
ansible-playbook playbooks/setup_postgres.yml --ask-vault-pass
```
2. Enter password for Ansible Vault
3. Done!