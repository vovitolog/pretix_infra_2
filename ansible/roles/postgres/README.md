# Postgres Role

This Ansible role deploys PostgreSQL in a Docker container on the backend server. It configures a secure PostgreSQL instance with persistent storage, suitable for production use alongside other backend services (e.g., Redis, RabbitMQ).

## Requirements

- Ansible 2.9 or higher.
- Debian (Ubuntu) -based system.
- Ansible Vault for managing encrypted secrets.

## Role Variables

Variables are split into two files in `defaults/main/`:
- `main.yml`: Non-sensitive variables (e.g., `postgres_version`, `postgres_port`).
- `secrets.yml`: Sensitive variables (e.g., `postgres_password`), encrypted with Ansible Vault.

### Main Variables (`defaults/main/main.yml`)
- `postgres_version`: PostgreSQL image tag (default: `17.5`).
- `postgres_port`: Port to expose (default: `5432`).
- `postgres_db`: Database name (default: `pretix`).
- `postgres_user`: Database user (default: `pretix`).
- `postgres_data_dir`: Data directory (default: `/opt/postgres/data`).
- `postgres_container_name`: Container name (default: `postgres`).
- `container_network`: Docker network (default: `backend`).

### Sensitive Variables (`defaults/main/secrets.yml`)
- `postgres_password`: Password for the database user (encrypted, default: `*****`).

## Playbook
Already configured playbook, which is in the directory with playbooks:
```yml!
# /ansible/playbooks/setup_postgresql.yml
- hosts: backend
  roles:
    - role: postgres
      vars:
        # By default, all variables are set correctly and do not require changes. You can change them if necessary
        # postgres_version: "17.5"                # PostgreSQL image tag
        # postgres_port: "5532"                   # Default port: 5432
        # postgres_data_dir: "/opt/postgres/data" # Persistent data directory
        # postgres_container_name: "postgres"     # Default container name
        # postgres_db: "pretix"                   # Default database name
        # postgres_user: "pretix"                 # Default database user
        # postgres_password: "*****"              # Default password for database user
        # container_network: "backend"            # Default network for container
```

## How to use

Playbook must be used from the directory `/ansible`

1. Run the command:
```bash
ansible-playbook playbooks/setup_postgres.yml --ask-vault-pass
```
2. Enter password for Ansible Vault
3. Done!