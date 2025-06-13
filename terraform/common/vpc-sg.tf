resource "yandex_vpc_security_group" "internet_allowed" {
  name        = "allow-internet"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Allow internet access for the instance, whether NATted or not"

  egress {
    protocol       = "ANY"
    description    = "Allow outbound connections to internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "proxy_default_sg" {
  name        = "proxy-default-sg"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Security group for reverse proxy"

  ingress {
    protocol       = "TCP"
    description    = "Allow SSH"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "ICMP"
    description    = "Allow pings for troubleshooting"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to dev subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from dev subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }
}

resource "yandex_vpc_security_group" "mon_default_sg" {
  name        = "mon-default-sg"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Security group for monitoring subnet"

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound internet connections. This rule is temporal"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to development subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from development subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to mvp subnet"
    v4_cidr_blocks = [var.mvp_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from mvp subnet"
    v4_cidr_blocks = [var.mvp_subnet_cidr]
  }
}

resource "yandex_vpc_security_group" "dev_default_sg" {
  name        = "dev-default-sg"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Security group for development subnet"

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow egress within development subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow ingress within development subnet"
    v4_cidr_blocks = [var.dev_subnet_cidr]
  }
}


resource "yandex_vpc_security_group" "prod_default_sg" {
  name        = "prod-default-sg"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Security group for production subnet"

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from reverse proxy subnet"
    v4_cidr_blocks = [var.proxy_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow egress within production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow ingress within production subnet"
    v4_cidr_blocks = [var.prod_subnet_cidr]
  }
}

resource "yandex_vpc_security_group" "mvp_default_sg" {
  name        = "mvp-default-sg"
  network_id  = yandex_vpc_network.pretix_vpc.id
  description = "Security group for mvp subnet"

  egress {
    protocol       = "ANY"
    description    = "Allow outbound to monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }

  ingress {
    protocol       = "ANY"
    description    = "Allow inbound from monitoring subnet"
    v4_cidr_blocks = [var.mon_subnet_cidr]
  }
}
