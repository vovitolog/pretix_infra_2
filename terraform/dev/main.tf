data "yandex_compute_image" "ubuntu" {
  family = var.vm_os_family
}

resource "yandex_compute_instance" "dev_singleton" {
  name        = "development-instance"
  platform_id = var.vm_platform
  zone        = var.default_zone

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    auto_delete = true
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.vm_disk_size
      type     = var.vm_disk_type
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
      ssh-keygen -f ~/.ssh/known_hosts -R dev.pretix.devops-factory.com
    EOT
  }
}