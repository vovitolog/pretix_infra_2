locals {
  # dev = data.terraform_remote_state.dev.outputs
  proxy_host = cidrhost(var.proxy_subnet_cidr, 3)
  mon_host   = cidrhost(var.mon_subnet_cidr, 6)
}
