output "mvp_net" {
  value = {
    cidr = var.mvp_subnet_cidr
    zone = var.mvp_zone
  }
}

output "dev_net" {
  value = {
    cidr = var.dev_subnet_cidr
    zone = var.dev_zone
  }
}

output "prod_net" {
  value = {
    cidr = var.prod_subnet_cidr
    zone = var.prod_zone
  }
}

output "mon_net" {
  value = {
    cidr = var.mon_subnet_cidr
    zone = var.mon_zone
  }
}

output "proxy_net" {
  value = {
    cidr       = var.proxy_subnet_cidr
    zone       = var.proxy_zone
    private_ip = local.proxy_host
    public_ip  = yandex_compute_instance.reverse_proxy.network_interface[0].nat_ip_address
  }
}
