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