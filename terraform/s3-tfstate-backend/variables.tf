variable "admin_sa_name" {
  type        = string
  description = "Default service account name with admin role"
  default     = "pretixsvc"
}

variable "tfstate_s3_bucket_name" {
  type        = string
  description = "Name of the bucket where terraform state is saved"
  default     = "devops-factory-pretix-tfstate-singleton"
}

variable "versioning" {
  type = object({
    is_enabled    = bool
    has_lifecycle = bool
    retention     = optional(number, 3)
  })

  default = {
    is_enabled    = true
    has_lifecycle = true
  }

  description = "S3 bucket storage versioning and its lifycecle. Retention period in days"

  validation {
    condition     = var.versioning.is_enabled || !var.versioning.has_lifecycle
    error_message = <<EOT
      "Retention lifecycle policy cannot be enbled while versioning is disabled.
      Versioning = {is_enabled = false, has_lifecycle = false}"
    EOT
  }
}

variable "ydb_db_name" {
  type        = string
  default     = "state-lock-db"
  description = "Name of the YDB database, where state lock table should be created."
}

variable "ydb_region" {
  type        = string
  default     = "ru-central1"
  description = "Location of YDB, region"
}

variable "aws_profile_user" {
  type        = string
  default     = "yandex-s3-tfstate"
  description = "AWS profile with given name will be created (with YC credentials, you can use it with Yandex cloud not AWS itself)"
}

variable "envs" {
  type        = list(string)
  default     = ["dev", "prod", "common"]
  description = "Environments supported"
}
