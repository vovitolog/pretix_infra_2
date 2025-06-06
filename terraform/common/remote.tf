data "terraform_remote_state" "dev" {
  backend = "s3"

  config = {
    endpoints = {
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g9v3ciql6vdgfm9c7e/etn31fbdukcue3h6svf2"
      s3       = "https://storage.yandexcloud.net"
    }

    profile                     = "s3-tfstate-user"
    dynamodb_table              = "dev-aws-dynamodb-lock-table"
    bucket                      = "devops-factory-pretix-tfstate-singleton"
    key                         = "state/dev.tfstate"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

# data "terraform_remote_state" "prod" {
#   backend = "s3"

#   config = {
#     endpoints = {
#       dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g9v3ciql6vdgfm9c7e/etn31fbdukcue3h6svf2"
#       s3       = "https://storage.yandexcloud.net"
#     }

#     profile                     = "s3-tfstate-user"
#     dynamodb_table              = "prod-aws-dynamodb-lock-table"
#     bucket                      = "devops-factory-pretix-tfstate-singleton"
#     key                         = "state/prod.tfstate"
#     region                      = "ru-central1"
#     skip_region_validation      = true
#     skip_credentials_validation = true
#     skip_requesting_account_id  = true
#     skip_s3_checksum            = true
#   }
# }
