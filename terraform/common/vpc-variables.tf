variable "mon_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Availability zone where main monitoring instance will be located"
}

variable "proxy_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Availability zone where reverse proxy will be located"
}

variable "dev_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Availability zone where dev instances will be located"
}

variable "prod_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Availability zone where dev instances will be located"
}

variable "mvp_zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Availability zone where mvp instance will be located"
}

variable "proxy_subnet_cidr" {
  type        = string
  default     = "10.130.1.0/24"
  description = "CIDR IP range for reverse proxy subnet"

  validation {
    condition     = can(cidrnetmask(var.proxy_subnet_cidr))
    error_message = "Provided CIDR is not valid"
  }
}

variable "mon_subnet_cidr" {
  type        = string
  default     = "10.130.4.0/24"
  description = "CIDR IP range for monitoring subnet"

  validation {
    condition     = can(cidrnetmask(var.mon_subnet_cidr))
    error_message = "Provided CIDR is not valid"
  }
}

variable "dev_subnet_cidr" {
  type        = string
  default     = "10.130.5.0/24"
  description = "CIDR IP range for development environment subnet"

  validation {
    condition     = can(cidrnetmask(var.dev_subnet_cidr))
    error_message = "Provided CIDR is not valid"
  }
}

variable "prod_subnet_cidr" {
  type        = string
  default     = "10.130.6.0/24"
  description = "CIDR IP range for production environment subnet"

  validation {
    condition     = can(cidrnetmask(var.prod_subnet_cidr))
    error_message = "Provided CIDR is not valid"
  }
}

variable "mvp_subnet_cidr" {
  type        = string
  default     = "10.130.0.0/24"
  description = "CIDR IP range for mvp subnet"

  validation {
    condition     = can(cidrnetmask(var.mvp_subnet_cidr))
    error_message = "Provided CIDR is not valid"
  }
}
