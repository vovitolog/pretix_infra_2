
variable "proxy_vm_memory" {
  type        = number
  default     = 4
  description = "RAM of the instance in GB"
}

variable "proxy_vm_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores vm will have"
}

variable "proxy_vm_disk_size" {
  type        = number
  default     = 50
  description = "Volume disk size in GB"
}

variable "proxy_vm_core_fraction" {
  type        = number
  default     = 50
  description = "How many CPU time fraction (in percents) is reserved"
}
