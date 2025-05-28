# Monitoring Stack Role

This Ansible role deploys a monitoring stack consisting of Prometheus, Alertmanager, Grafana, and Blackbox Exporter using Docker Compose. It configures Prometheus to monitor with HTTP probing for Grafana availability. Alertmanager is set up to send notifications to Telegram, and a sample alert rule is included to detect Grafana downtime.

## Requirements

- Ansible 2.9 or higher.
- Docker and Docker Compose installed on the target host (automatically handled by the role).
- Ubuntu-based system (role uses `apt` for package installation).
- Access to Docker Hub for pulling the latest images of `prom/prometheus`, `prom/alertmanager`, `grafana/grafana`, and `prom/blackbox-exporter`.
- A valid Telegram bot token and chat ID for Alertmanager notifications.

## Role Variables

Variables are defined in `defaults/main.yml`:

- `grafana_admin_password`: Password for Grafana admin user (default: `admin123`). **Change to a secure password in production.**
- `telegram_bot_token`: Telegram bot token for Alertmanager notifications (default: `your_bot_token_here`). Obtain from @BotFather.
- `telegram_chat_id`: Telegram chat ID for notifications (default: `0`). Must be a number, not a string. Obtain from @GetIDsBot.
- `grafana_host`: Host and port for Grafana probing (default: `grafana:3000`). Used by Blackbox Exporter for HTTP checks.

## Dependencies

None. This role is self-contained and does not depend on other Ansible roles.

## Example Playbook

```yaml
- hosts: monitoring_servers
  roles:
    - role: monitoring_stack
      vars:
        grafana_admin_password: "PASSWORD"
        telegram_bot_token: "BOT_TOKEN"
        telegram_chat_id: "CHAT_ID"
        grafana_host: "grafana:3000"
```
Variables can also be changed in the file: `roles/monitoring_stack/defaults/main`:

```
---
grafana_admin_password: "PASSWORD"
telegram_bot_token: "BOT_TOKEN"
telegram_chat_id: "CHAT_ID"
```

Save this as `playbook.yml` and run with:
```bash
ansible-playbook playbook.yml
```

After deployment:
- Prometheus: `http://<host>:9090`
- Alertmanager: `http://<host>:9093`
- Grafana: `http://<host>:3000` (login: admin, password: as set in `grafana_admin_password`)
- Blackbox Exporter: `http://<host>:9115`
