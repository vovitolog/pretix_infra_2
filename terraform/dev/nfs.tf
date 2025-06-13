data "yandex_compute_image" "nfs" {
  family = var.nfs_os_family
}

resource "yandex_compute_instance" "nfs_dev" {
  name        = "nfs-for-dev"
  hostname    = var.nfs_dns_name
  platform_id = var.vm_platform
  zone        = local.common.dev_net.zone

  resources {
    cores         = var.nfs_cores
    memory        = var.nfs_memory
    core_fraction = var.nfs_core_fraction
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.nfs.id
      size     = var.nfs_disk_size
      type     = var.vm_disk_type
    }
  }

  network_interface {
    subnet_id  = data.yandex_vpc_subnet.development.id
    nat        = false
    ip_address = cidrhost(local.common.dev_net.cidr, 4)
    security_group_ids = [
      local.common.sg_id.dev_default,
      local.common.sg_id.internet_egress
    ]
    dns_record {
      fqdn = "${var.nfs_dns_name}."
      ttl  = 300
    }
  }

  scheduling_policy {
    preemptible = false
  }

  metadata = {
    user-data = templatefile("${path.module}/nfs-user-data.yaml.tftpl", {
      users      = var.users
      services   = var.service_users
      proxy_cidr = local.common.proxy_net.cidr
      dev_cidr   = local.common.dev_net.cidr
    })
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      ssh-keygen -f ~/.ssh/known_hosts -R ${self.network_interface[0].ip_address}
      ssh-keygen -f ~/.ssh/known_hosts -R ${self.hostname}
    EOT
  }
}
