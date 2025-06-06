variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Default OS image to use"
}

variable "vm_core_fraction" {
  type        = number
  default     = 20
  description = "How many CPU time fraction (in percent) is reserved"
}

variable "zone" {
  type        = string
  default     = "ru-central1-d"
  description = "Default zone, if not specified will be used"
}

