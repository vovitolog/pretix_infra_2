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
    # private_ip = try()
  }
}

output "proxy_net" {
  value = {
    cidr       = var.proxy_subnet_cidr
    zone       = var.proxy_zone
    private_ip = local.proxy_host
    public_ip  = try(yandex_compute_instance.reverse_proxy.network_interface[0].nat_ip_address, null)
  }
}

output "sg_id" {
  description = "Security group ids, to apply on network interfaces of compute instances"
  value = {
    internet_egress = yandex_vpc_security_group.internet_allowed.id
    proxy_default   = yandex_vpc_security_group.proxy_default_sg.id
    mon_default     = yandex_vpc_security_group.mon_default_sg.id
    dev_default     = yandex_vpc_security_group.dev_default_sg.id
    prod_default    = yandex_vpc_security_group.prod_default_sg.id
    mvp_default     = yandex_vpc_security_group.mvp_default_sg.id
  }
}
