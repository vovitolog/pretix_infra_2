# Cloud-init configuration used for initializing instances
data "cloudinit_config" "common_config" {
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init.tpl", {
      default_ssh_key = var.default_ssh_key
      users           = var.users
    })
  }
}

# Default network in Yandex Cloud
data "yandex_vpc_network" "default" {
  name = "default"
}

# Default subnet in zone 'ru-central1-d'
data "yandex_vpc_subnet" "default" {
  name = "default-ru-central1-d"
}

# Static public IP address for the frontend instance
resource "yandex_vpc_address" "frontend_ip" {
  name = "frontend-static-ip"
  external_ipv4_address {
    zone_id = "ru-central1-d"
  }
}

# Static public IP address for the monitoring instance
resource "yandex_vpc_address" "monitoring_ip" {
  name = "monitoring-static-ip"
  external_ipv4_address {
    zone_id = "ru-central1-d"
  }
}

# Frontend instance configuration
resource "yandex_compute_instance" "frontend" {
  name        = "frontend"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd88o3huv4mm2jndnrl1" # Ubuntu 24.04
      size     = 50
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id      = data.yandex_vpc_subnet.default.id
    nat            = true
    nat_ip_address = yandex_vpc_address.frontend_ip.external_ipv4_address[0].address
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = data.cloudinit_config.common_config.rendered
  }
}

# Backend instance configuration
resource "yandex_compute_instance" "backend" {
  name        = "backend"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 8
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd88o3huv4mm2jndnrl1" # Ubuntu 24.04
      size     = 50
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = data.yandex_vpc_subnet.default.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = data.cloudinit_config.common_config.rendered
  }
}

# Monitoring instance configuration
resource "yandex_compute_instance" "monitoring" {
  name        = "monitoring"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 4
    core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd88o3huv4mm2jndnrl1" # Ubuntu 24.04
      size     = 50
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id      = data.yandex_vpc_subnet.default.id
    nat            = true
    nat_ip_address = yandex_vpc_address.monitoring_ip.external_ipv4_address[0].address
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = data.cloudinit_config.common_config.rendered
  }
}