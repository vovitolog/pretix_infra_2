variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Default OS image to use"
}

variable "vm_core_fraction" {
  type        = number
  default     = 20
  description = "How many CPU time fraction (in percents) is reserved"
}

variable "zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Default zone, if not specified will be used"
}


variable "gitlab_runner_token" {
  type        = string
  sensitive   = true
  description = "The necessary GitLab runner token to authenticate GitLab runner"
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

variable "vm_platform" {
  type        = string
  default     = "standard-v3"
  description = "ID of the CPU architecture"
}

variable "vm_disk_size" {
  type        = number
  default     = 20
  description = "Volume disk size in GB"
}

variable "vm_disk_type" {
  type    = string
  default = "network-ssd"
}

variable "vm_memory" {
  type        = number
  default     = 4
  description = "RAM of the instance in GB"
}

variable "vm_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores vm will have"
}
