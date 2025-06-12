resource "yandex_vpc_network" "pretix_vpc" {
  name        = "pretix-vpc"
  description = "Main Pretix network"
}

resource "yandex_vpc_route_table" "nat_route_table" {
  name       = "nat-via-reverse-proxy"
  network_id = yandex_vpc_network.pretix_vpc.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = local.proxy_host # yandex_compute_instance.reverse_proxy.network_interface.0.ip_address
  }
}

resource "yandex_vpc_subnet" "proxy" {
  name           = "reverse-proxy"
  network_id     = yandex_vpc_network.pretix_vpc.id
  zone           = var.proxy_zone
  v4_cidr_blocks = [var.proxy_subnet_cidr]
  description    = "Reverse proxy subnet"
}

resource "yandex_vpc_subnet" "mvp" {
  name           = "mvp"
  network_id     = yandex_vpc_network.pretix_vpc.id
  zone           = var.mvp_zone
  v4_cidr_blocks = [var.mvp_subnet_cidr]
  description    = "MVP subnet"
}

resource "yandex_vpc_subnet" "monitoring" {
  name           = "moniotiring"
  network_id     = yandex_vpc_network.pretix_vpc.id
  zone           = var.mon_zone
  v4_cidr_blocks = [var.mon_subnet_cidr]
  description    = "Monitoring subnet"
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}

resource "yandex_vpc_subnet" "development" {
  name           = "development"
  network_id     = yandex_vpc_network.pretix_vpc.id
  zone           = var.dev_zone
  v4_cidr_blocks = [var.dev_subnet_cidr]
  description    = "Development environment subnet"
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}

resource "yandex_vpc_subnet" "production" {
  name           = "production"
  network_id     = yandex_vpc_network.pretix_vpc.id
  zone           = var.prod_zone
  v4_cidr_blocks = [var.prod_subnet_cidr]
  description    = "Production environment subnet"
  route_table_id = yandex_vpc_route_table.nat_route_table.id
}
