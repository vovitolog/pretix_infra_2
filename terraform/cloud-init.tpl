#cloud-config
datasource:
  ConfigDrive:
    strict_id: false

ssh_pwauth: false

users:
  - name: kholopovdi
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${default_ssh_key}

%{ for user, key in users ~}
  - name: ${user}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${key}
%{ endfor }

package_update: true
package_upgrade: true
packages:
  - openssh-server
  - vi
  - python3
  - curl
runcmd:
  - curl -fsL https://get.docker.com/ | sh

