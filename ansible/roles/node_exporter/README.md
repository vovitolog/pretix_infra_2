# Node Exporter Deployment with Ansible

This Ansible playbook deploys Prometheus Node Exporter as a Docker container for collecting host system metrics.

## Overview

The playbook performs the following:
- Verifies Docker installation and permissions
- Creates necessary directories for configuration
- Deploys Node Exporter container with proper volume mounts and flags

## Features

- Uses official Prometheus Node Exporter Docker image
- Properly mounts host filesystems for metrics collection
- Persistent configuration directory
- Automatic restart policy
- Pre-configured collectors with excluded mount points

## Requirements

- Ansible 2.9+
- Docker installed and running
- User running the playbook must:
  - Have Docker installed
  - Be in the `docker` group
  - Have permission to create directories
- Linux host (tested on Ubuntu/Debian)

## Installation

1. Ensure Docker is installed and your user is in the docker group:
```
sudo apt-get install docker.io
sudo usermod -aG docker $USER
newgrp docker  # Reload group permissions
```

2. Clone the repository (if applicable) or create a playbook file with the provided content.

3. Customize variables if needed in your playbook:
```
node_exporter_version: "1.8.2"  # Node Exporter version
node_exporter_port: 9100       # Port to expose
node_exporter_config_dir: "/home/pipeline/monitoring/node_exporter"  # Config directory
```

4. Run the playbook:
```
ansible-playbook playbooks/node_exporter_deploy.yml
```

## Configuration

### Volume Mounts
The container mounts:
- `/proc` - Process metrics
- `/sys` - System metrics
- `/` - Root filesystem
- Custom config directory

### Command Flags
Node Exporter runs with:
```
--path.procfs=/host/proc
--path.sysfs=/host/sys
--path.rootfs=/rootfs
```
- Filters out system mount points from filesystem metrics

## Access

After deployment, Node Exporter metrics will be available at:
```
http://<host>:9100/metrics
```

## Verification

Check container status:
```
docker ps -f name=node_exporter
```

Check metrics:
```
curl http://localhost:9100/metrics
```

## Maintenance

### Restarting
```
docker restart node_exporter
```

### Upgrading
Change the `node_exporter_version` variable and re-run the playbook.

### Removing
```
docker stop node_exporter
docker rm node_exporter
```