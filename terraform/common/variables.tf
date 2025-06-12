variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Default OS image to use"
}

variable "vm_disk_type" {
  type    = string
  default = "network-ssd"
}

variable "vm_platform" {
  type        = string
  default     = "standard-v3"
  description = "ID of the CPU architecture"
}

variable "users" {
  type = list(object({
    name         = string
    ssh_pub_keys = list(string)
  }))

  validation {
    condition = alltrue([
      for user in var.users : length(user.ssh_pub_keys) > 0
    ])
    error_message = <<EOT
      Each user must have at least one SSH public key in ssh_pub_keys.
    EOT
  }
}

variable "service_users" {
  type = list(object({
    name        = string
    ssh_pub_key = string
    is_sudoer   = optional(bool, false)
  }))
}
