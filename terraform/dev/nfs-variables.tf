variable "nfs_os_family" {
  type        = string
  default     = "debian-12"
  description = "Default OS image for NFS server"
}

variable "nfs_core_fraction" {
  type        = number
  default     = 20
  description = "How many CPU time fractions NFS server has"
}

variable "nfs_disk_size" {
  type        = number
  default     = 10
  description = "NFS Volume disk size in GB"
}

variable "nfs_memory" {
  type        = number
  default     = 2
  description = "RAM of the instance in GB"
}

variable "nfs_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores NFS server will have"
}

variable "nfs_dns_name" {
  type        = string
  default     = "nfs-dev.pretix.devops-factory.com"
  description = "Internal DNS name of dev NFS server, without dot at the end"
}
