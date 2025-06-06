terraform {
  required_version = "~> 1.12.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.142"
    }
  }

  backend "s3" {
    endpoints = {
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g9v3ciql6vdgfm9c7e/etn31fbdukcue3h6svf2"
      s3       = "https://storage.yandexcloud.net"
    }

    profile                     = "s3-tfstate-user"
    dynamodb_table              = "prod-aws-dynamodb-lock-table"
    bucket                      = "devops-factory-pretix-tfstate-singleton"
    key                         = "state/prod.tfstate"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file(var.key_path)
}
