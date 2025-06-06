terraform {
  required_version = "~> 1.12.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.142"
    }
  }

  backend "http" {
    address        = "https://gitlab.pretix.devops-factory.com/api/v4/projects/8/terraform/state/bucket-tfstate"
    lock_address   = "https://gitlab.pretix.devops-factory.com/api/v4/projects/8/terraform/state/bucket-tfstate/lock"
    unlock_address = "https://gitlab.pretix.devops-factory.com/api/v4/projects/8/terraform/state/bucket-tfstate/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = "5"
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file(var.key_path)
}
