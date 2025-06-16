# GitLab Runner Docker Role

This Ansible role deploys GitLab Runner inside a Docker container. It registers the runner with your GitLab instance using a provided token and launches the container with persistent configuration and Docker socket access for Docker-in-Docker builds.

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

* `defaults/main/main.yml`: Non-sensitive variables (e.g., `image`, `container_name`, `gitlab_url`).
* `defaults/main/secret.yml`: Sensitive variables (e.g., `gitlab_runner_token`), encrypted with Ansible Vault.

### Main Variables (`defaults/main/main.yml`)

* `container_name`: Name of the GitLab Runner container (default: `gitlab-runner`).
* `image`: Docker image name (default: `gitlab/gitlab-runner:latest`).
* `gitlab_url`: GitLab instance URL (default: `https://gitlab.pretix.devops-factory.com`).
* `restart_policy`: Docker container restart policy (default: `unless-stopped`).

### Sensitive Variables (`defaults/main/secret.yml`)

* `gitlab_runner_token`: Registration token for GitLab Runner (encrypted with Ansible Vault).

## Playbook

Example playbook to set up GitLab Runner in Docker:

```yaml
# /ansible/playbooks/setup_gitlab_runner_docker.yml
- hosts: mvp
  become: true
  collections:
    - community.docker
  roles:
    - role: gitlab-runner-docker
      vars:
        # By default, variables are correctly set and usually do not require changes.
        # You can override them if necessary:
        # container_name: "gitlab-runner"
        # image: "gitlab/gitlab-runner:latest"
        # gitlab_url: "https://gitlab.pretix.devops-factory.com"
        # gitlab_runner_token: "encrypted with Ansible Vault"
        # restart_policy: "unless-stopped"
```

## How to Use

Playbook must be executed from the `/ansible` directory.

1. Run the command:

```bash
ansible-playbook playbooks/setup_gitlab_runner_docker.yml -J
```

2. Enter the password for Ansible Vault when prompted.
3. GitLab Runner will be registered and deployed inside a Docker container, ready to pick up jobs!

## What This Role Does

The role performs the following actions:

1. Verifies Docker API is available on the target host.
2. Registers GitLab Runner using the provided token in a temporary container.
3. Pulls (or updates) the specified GitLab Runner Docker image.
4. Launches the GitLab Runner container with the necessary volumes:

   * `runner_data` volume for configuration persistence.
   * Bind mount of Docker socket for Docker-in-Docker builds.
5. Ensures the container runs with the specified restart policy.
