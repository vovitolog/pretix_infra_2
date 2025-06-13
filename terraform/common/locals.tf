locals {
  # dev = data.terraform_remote_state.dev.outputs
  proxy_host = cidrhost(var.proxy_subnet_cidr, 3)
}
