# RabbitMQ Role

This Ansible role deploys RabbitMQ on a Debian-based server. It installs Erlang, sets up RabbitMQ repositories, imports signing keys, configures RabbitMQ, enables the management plugin, and creates an administrator user.

## Requirements

* Ansible 2.9.10 or higher.
* Debian or Ubuntu-based system.
* Ansible Vault for managing encrypted secrets.

## Role Variables

Variables are split into two files:

* `defaults/main/main.yml`: Non-sensitive variables (e.g., `rabbitmq_admin`).
* `defaults/main/secret.yml`: Sensitive variables (e.g., `rabbitmq_admin_pass`), encrypted with Ansible Vault.

### Main Variables (`defaults/main/main.yml`)

* `rabbitmq_admin`: Name of the RabbitMQ administrator user (default: `admin`).

### Sensitive Variables (`defaults/main/secret.yml`)

* `rabbitmq_admin_pass`: Password for the RabbitMQ administrator user (encrypted, default: `******`).


### Internal Variables (`vars/main.yml`)

These variables are defined internally for the role operation and typically not overridden:

* `requirements`: List of packages required to add repositories (`curl`, `gnupg`, `apt-transport-https`).
* `erlang_package`: List of Erlang packages to install.
* `rabbitmq_signing_key`: URLs for RabbitMQ GPG signing keys.
* `rabbitmq_repos`: RabbitMQ repository information in `deb822` format.

## Playbook

Example playbook to set up RabbitMQ:

```yaml
# /ansible/playbooks/setup_rabbitmq.yml
- hosts: backend
  become: true
  roles:
    - role: rabbitmq
      vars:
        # By default, variables are correctly set and usually do not require changes.
        # You can override them if necessary:
        # rabbitmq_admin: "admin"              # Administrator username
        # rabbitmq_admin_pass: "********"      # Administrator password (from Vault)
```

## How to Use

Playbook must be executed from the `/ansible` directory.

1. Run the command:

```bash
ansible-playbook playbooks/setup_rabbitmq.yml --ask-vault-pass
```

2. Enter the password for Ansible Vault when prompted.
3. RabbitMQ will be installed, configured, and ready to use!

## What This Role Does

The role performs the following actions:

1. Installs prerequisite packages.
2. Downloads RabbitMQ GPG signing keys.
3. Adds RabbitMQ repositories using `deb822_repository`.
4. Installs Erlang packages.
5. Installs RabbitMQ.
6. Enables and starts the RabbitMQ service.
7. Enables the RabbitMQ management plugin.
8. Creates an admin user with full privileges.



## Notes

* This role is tested on Ubuntu 24.04
