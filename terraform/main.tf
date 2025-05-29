# Local variable defining instance configurations
locals {
  instances = {
    frontend = {
      name           = "frontend"
      platform       = var.vm_platform_id
      zone           = var.vm_zone
      cores          = 2
      memory         = 4
      core_fraction  = var.vm_core_fraction
      disk_size      = var.vm_disk_size
      disk_type      = var.vm_disk_type
      nat            = true
      # Use a static IP if available, otherwise fallback to empty string
      nat_ip_address = try(yandex_vpc_address.static_ips["frontend"].external_ipv4_address[0].address, "")
      preemptible    = var.vm_preemptible
    },
    backend = {
      name           = "backend"
      platform       = var.vm_platform_id
      zone           = var.vm_zone
      cores          = 2
      memory         = 8
      core_fraction  = var.vm_core_fraction
      disk_size      = var.vm_disk_size
      disk_type      = var.vm_disk_type
      nat            = true
      # No static IP assigned for backend
      nat_ip_address = ""
      preemptible    = var.vm_preemptible
    },
    monitoring = {
      name           = "monitoring"
      platform       = var.vm_platform_id
      zone           = var.vm_zone
      cores          = 2
      memory         = 4
      core_fraction  = var.vm_core_fraction
      disk_size      = var.vm_disk_size
      disk_type      = var.vm_disk_type
      nat            = true
      # Use a static IP if available, otherwise fallback to empty string
      nat_ip_address = try(yandex_vpc_address.static_ips["monitoring"].external_ipv4_address[0].address, "")
      preemptible    = var.vm_preemptible
    }
  }
}

# Define static public IPs for specific instances
locals {
  static_ips = {
    frontend   = { name = "frontend-static-ip", zone = var.vm_zone }
    monitoring = { name = "monitoring-static-ip", zone = var.vm_zone }
  }
}

# Create static public IPs in Yandex Cloud
resource "yandex_vpc_address" "static_ips" {
  for_each = local.static_ips
  name     = each.value.name
  external_ipv4_address {
    zone_id = each.value.zone
  }
}

# Cloud-init configuration used for all VMs
data "cloudinit_config" "common_config" {
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-init.tpl", {
      default_ssh_key = var.default_ssh_key
      users           = var.users
    })
  }
}

# Fetch default VPC network and subnet
data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "default" {
  name = "default-${var.vm_zone}"
}

# Get the latest Ubuntu image based on family
data "yandex_compute_image" "ubuntu" {
  family = var.vm_os_family
}

# Create compute instances dynamically using the instance definitions
resource "yandex_compute_instance" "instances" {
  for_each    = local.instances
  name        = each.value.name
  platform_id = each.value.platform
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = each.value.disk_size
      type     = each.value.disk_type
    }
  }

  network_interface {
    subnet_id      = data.yandex_vpc_subnet.default.id
    nat            = each.value.nat
    nat_ip_address = each.value.nat_ip_address
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  metadata = {
    user-data = data.cloudinit_config.common_config.rendered
  }
}