data "yandex_compute_image" "ubuntu" {
  family = var.vm_os_family
}

resource "yandex_compute_instance" "reverse_proxy" {
  name        = "reverse-proxy-nginx"
  hostname    = "nginx.pretix.devops-factory.com"
  platform_id = var.vm_platform
  zone        = var.proxy_zone

  resources {
    cores         = var.proxy_vm_cores
    memory        = var.proxy_vm_memory
    core_fraction = var.proxy_vm_core_fraction
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.proxy_vm_disk_size
      type     = var.vm_disk_type
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.proxy.id
    nat        = true
    ip_address = local.proxy_host
    security_group_ids = [
      yandex_vpc_security_group.proxy_default_sg.id,
      yandex_vpc_security_group.internet_allowed.id
    ]
    dns_record {
      fqdn = "nginx.pretix.devops-factory.com."
      ttl  = 300
    }
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = templatefile("${path.module}/proxy-user-data.yaml.tftpl", {
      users    = var.users
      services = var.service_users
    })
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      ssh-keygen -f ~/.ssh/known_hosts -R ${self.network_interface[0].nat_ip_address}
      ssh-keygen -f ~/.ssh/known_hosts -R nginx.pretix.devops-factory.com
      ssh-keygen -f ~/.ssh/known_hosts -R pretix.devops-factory.com
    EOT
  }
}
