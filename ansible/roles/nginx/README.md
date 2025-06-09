# Deploy IaC component: Web server

Thats role is for start Nginx in Docker Container

## Requirements

On a target instance must be installed Docker. Role doesnt install Docker

## Role Variables

| Variable             | Comment             |
|------------------------|----------------------|
| `image`    | Name of image              |
| `container_name`  | Name of container   |
| `ports`    | Host:Conatiner  |
| `restart_policy` | Policy of restart container          |

## Dependencies

Должна быть установлена коллекция
We need to install collection:
```bash
ansible-galaxy collection install community.docker
```

## How to use

We need to add hosts in `inventory.yml` where must be installed role:
```yaml!
[mvp]
mvp_host ansible_host=123.456.78.9
```

Run!:
```bash!
ansible-playbook playbooks/setup_nginx.yml
```
