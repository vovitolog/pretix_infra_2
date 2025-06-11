data "yandex_compute_image" "ubuntu" {
  family = var.mon_vm_os_family
}

resource "yandex_compute_instance" "monitoring" {
  name        = "monitoring-instance"
  platform_id = var.mon_vm_platform
  zone        = var.default_zone

  resources {
    cores         = var.mon_vm_cores
    memory        = var.mon_vm_memory
    core_fraction = var.mon_vm_core_fraction
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.mon_vm_disk_size
      type     = var.mon_vm_disk_type
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.d-subnet.id
    nat       = true
  }

  scheduling_policy {
    preemptible = false
  }

  metadata = {
    user-data = templatefile("${path.module}/user-data.yaml.tftpl", {
      users    = var.users
      services = var.service_users
    })
    runner-token = var.gitlab_runner_token
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      ssh-keygen -f ~/.ssh/known_hosts -R ${self.network_interface[0].nat_ip_address}
    EOT
  }
}