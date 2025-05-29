# Variable to store the OAuth token for authenticating with Yandex Cloud
variable "token" {
  description = "OAuth token for accessing Yandex Cloud"
  type        = string
}

# Variable to specify the Cloud ID in Yandex Cloud
variable "cloud_id" {
  description = "ID of the cloud in Yandex Cloud"
  type        = string
}

# Variable to specify the Folder ID (similar to a project) in Yandex Cloud
variable "folder_id" {
  description = "ID of the folder in Yandex Cloud"
  type        = string
}

# Variable to store the default SSH key for the user 'kholopovdi'
variable "default_ssh_key" {
  description = "SSH key for the user 'kholopovdi'"
  type        = string
}

# Variable to store a map of users and their corresponding SSH keys
variable "users" {
  description = "Map of usernames and their SSH keys"
  type        = map(string)
}

# Variable to store the path to the service account JSON key file
variable "service_account_key_file" {
  description = "Path to the service account key file (JSON)"
  type        = string
}

# General VM parameters
variable "vm_platform_id" {
  type    = string
  default = "standard-v3" 
}

variable "vm_zone" {
  type    = string
  default = "ru-central1-d"
}

variable "vm_disk_size" {
  type    = number
  default = 50
}

variable "vm_disk_type" {
  type    = string
  default = "network-ssd"
}

variable "vm_preemptible" {
  type    = bool
  default = true
}

variable "vm_core_fraction" {
  type    = number
  default = 50
}

variable "vm_os_family" {
  type        = string
  default     = "ubuntu-2404-lts"
}