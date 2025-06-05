# Redis Docker Role

This Ansible role deploys Redis inside a Docker container. It pulls the Redis image, creates necessary volumes, configures ports, and runs the container with persistent storage and network settings.

## Requirements

* Ansible 2.15.0 or higher.
* Docker must be pre-installed on the target host.
* `community.docker` Ansible collection.

Install the required collection with:

```bash
ansible-galaxy collection install community.docker
```

## Role Variables

Variables are defined in `defaults/main.yml`:

### Main Variables (`defaults/main.yml`)

* `image`: Docker image name (default: `redis:8.0.1-alpine`).
* `container_name`: Name of the Redis container (default: `pretix-redis`).
* `ports`: List of ports to expose (default: `127.0.0.1:6379:6379`).
* `volumes`: Docker volume name for Redis data persistence (default: `redis_data`).
* `restart_policy`: Docker container restart policy (default: `always`).
* `network_name`: Docker network name to attach the container to (default: `pretix-network`).

## Playbook

Example playbook to set up Redis in Docker:

```yaml
# /ansible/playbooks/setup_redis.yml
- hosts: mvp
  become: true
  collections:
    - community.docker
  roles:
    - role: redis
      vars:
        # By default, variables are correctly set and usually do not require changes.
        # You can override them if necessary:
        # image: "redis:8.0.1-alpine"
        # container_name: "pretix-redis"
        # ports:
        #   - "127.0.0.1:6379:6379"
        # volumes: "redis_data"
        # restart_policy: "always"
        # network_name: "pretix-network"
```

## How to Use

Playbook must be executed from the `/ansible` directory.

1. Run the command:

```bash
ansible-playbook playbooks/setup_redis.yml
```

2. Redis will be deployed inside a Docker container and ready to use!

## What This Role Does

The role performs the following actions:

1. Verifies Docker API is available on the target host.
2. Creates a Docker volume for Redis data persistence.
3. Pulls (or updates) the specified Redis Docker image.
4. Ensures the specified Docker network exists.
5. Runs the Redis container with specified configurations (ports, volume, restart policy, network).
