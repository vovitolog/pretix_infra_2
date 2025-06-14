data "yandex_compute_image" "monitoring" {
  family = var.mon_vm_os_family
}

data "yandex_dns_zone" "internal_zone" {
  name = "pretix"
}

resource "yandex_compute_instance" "monitoring" {
  name        = "monitoring-instance"
  platform_id = var.mon_vm_platform
  zone        = var.mon_zone
  hostname    = var.mon_dns_name

resources {
    cores         = var.mon_vm_cores
    memory        = var.mon_vm_memory
    core_fraction = var.mon_vm_core_fraction
  }
  
  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.monitoring.id
      size     = var.mon_vm_disk_size
      type     = var.mon_vm_disk_type
    }
  }
 
  network_interface {
    subnet_id          = yandex_vpc_subnet.monitoring.id
    nat                = true
    security_group_ids = [
      yandex_vpc_security_group.mon_default_sg.id,
      yandex_vpc_security_group.internet_allowed.id
    ]
    ip_address = cidrhost(var.mon_subnet_cidr, 6)
  }

  scheduling_policy {
    preemptible = false
  }

  metadata = {
    user-data = templatefile("${path.module}/mon.user-data.yaml.tftpl", {
      users    = var.users
      services = var.service_users
    })
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      ssh-keygen -f ~/.ssh/known_hosts -R ${self.network_interface[0].nat_ip_address}
    EOT
  }
}

resource "yandex_dns_recordset" "monitoring" {
  zone_id = data.yandex_dns_zone.internal_zone.id
  name    = "${var.mon_dns_name}.${data.yandex_dns_zone.internal_zone.name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.monitoring.network_interface[0].ip_address]
}