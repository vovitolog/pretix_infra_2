# Monitoring Stack Deployment

This Ansible role deploys a complete monitoring stack with Prometheus, Alertmanager, Grafana, and supporting exporters using Docker containers. The stack is pre-configured with Telegram notifications and sample alert rules.

## Stack Components

- **Prometheus** - Metrics collection and alert evaluation
- **Alertmanager** - Alert routing and notification management
- **Grafana** - Metrics visualization and dashboards
- **Blackbox Exporter** - HTTP/HTTPS endpoint monitoring

## Features

- Pre-configured Telegram notifications with thread support
- Sample alert rules for service monitoring
- Persistent storage for all components
- Automatic restart policies
- Role-based alert routing (Infrastructure, Network, Application, etc.)

## Requirements

- Ansible 2.9+
- Docker and Docker Compose
- Linux host (tested on Ubuntu 20.04/22.04)
- Python 3.x
- Telegram bot token and chat ID

## Installation

1. Clone the repository:
```
git clone <your-repo-url>
cd ansible-monitoring-stack
```

2. Configure variables in `playbooks/setup_monitoring_stack.yml`:
```
- name: Deploy monitoring stack
  hosts: monitoring
  roles:
    roles:
    - role: monitoring_stack
      vars:
        # Network configuration for Docker containers
        # Defines the Docker network used by the monitoring stack
        # container_network: "monitoring_network"

        # Telegram configuration for alert notifications
        
        # Chat ID for sending alerts to a Telegram group or channel
        # alerts_send_telegram_chat_id: 0

        # Telegram thread IDs for categorized alert routing
        
        # Infrastructure-related alerts thread
        # telegram_infrastructure_thread_id: 0
        
        # Network-related alerts thread
        # telegram_network_thread_id: 0
        
        # Application-related alerts thread
        # telegram_application_thread_id: 0
        
        # Database-related alerts thread
        # telegram_database_thread_id: 0
        
        # Security-related alerts thread
        # telegram_security_thread_id: 0

        # Sensitive credentials (should be stored in defaults/main/secret.yml)
        
        # Telegram bot token for sending notifications
        # telegram_bot_token: "***"
        
        # Grafana admin user password
        # grafana_admin_password: "***"
```

3. Run the playbook:
```
ansible-playbook -i inventory site.yml
```

## Configuration

### Alertmanager
- Configuration: `templates/alertmanager.yml.j2`
- Telegram templates: `files/telegram.tmpl`
- Routes alerts by category to different Telegram threads

### Prometheus
- Main config: `files/prometheus.yml`
- Alert rules: `files/rules.yml`
- Monitors:
  - Host metrics via Node Exporter
  - HTTP endpoints via Blackbox
  - All stack components

### Grafana
- Pre-configured with admin password
- Persistent storage
- Accessible on port 3000

## Access URLs

After deployment:
- Prometheus: `http://<host>:9090`
- Alertmanager: `http://<host>:9093` 
- Grafana: `http://<host>:3000` (admin/your_password)
- Blackbox Exporter: `http://<host>:9115`

## Customization

### Adding Alert Rules
Edit `files/rules.yml` following Prometheus alerting rules syntax.

Example:
```
groups:
- name: example
  rules:
  - alert: ServiceDown
    expr: up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Service {{ $labels.instance }} is down"
```

### Modifying Telegram Notifications
Edit `files/telegram.tmpl` to change notification format. Uses Go template syntax.

### Adding New Receivers
Edit `templates/alertmanager.yml.j2` to add new notification channels.

## Maintenance

To restart all services:
```
docker-compose -f /home/pipeline/monitoring/docker-compose.yml restart
```

To view logs:
```
docker-compose -f /home/pipeline/monitoring/docker-compose.yml logs -f
```

## Troubleshooting

Common issues:
- **Docker permissions**: Ensure user is in docker group
- **Template errors**: Check Alertmanager logs for template syntax issues
- **Telegram notifications**: Verify bot token and chat ID in `defaults/secret.yml`
