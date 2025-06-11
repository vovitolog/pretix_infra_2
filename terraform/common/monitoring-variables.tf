variable "mon_vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
  description = "Default OS image to use"
}

variable "mon_vm_core_fraction" {
  type        = number
  default     = 20
  description = "How many CPU time fraction (in percents) is reserved"
}


variable "mon_vm_platform" {
  type        = string
  default     = "standard-v3"
  description = "ID of the CPU architecture"
}

variable "mon_vm_disk_size" {
  type        = number
  default     = 50
  description = "Volume disk size in GB"
}

variable "mon_vm_disk_type" {
  type    = string
  default = "network-ssd"
}

variable "mon_vm_memory" {
  type        = number
  default     = 4
  description = "RAM of the instance in GB"
}

variable "mon_vm_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores vm will have"
}