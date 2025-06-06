resource "yandex_ydb_database_serverless" "ydb-lock-db" {
  name        = var.ydb_db_name
  folder_id   = var.folder_id
  location_id = var.ydb_region
}

resource "yandex_ydb_database_iam_binding" "editor" {
  database_id = yandex_ydb_database_serverless.ydb-lock-db.id
  role        = "ydb.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.tfstate_manager.id}"
  ]
}

resource "terraform_data" "dynamodb_table" {
  count      = length(var.envs)
  depends_on = [yandex_ydb_database_iam_binding.editor, terraform_data.tfstate_admin_setup]

  triggers_replace = [
    yandex_ydb_database_serverless.ydb-lock-db.id,
  ]

  input = {
    table_name       = "${var.envs[count.index]}-aws-dynamodb-lock-table"
    doc_api_endpoint = yandex_ydb_database_serverless.ydb-lock-db.document_api_endpoint
    access_key       = local.tfstate_admin_keys.access_key
    secret_key       = local.tfstate_admin_keys.secret_key
    region           = var.ydb_region
  }

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    command    = <<EOT
      aws dynamodb create-table \
        --table-name ${self.input.table_name} \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --endpoint ${yandex_ydb_database_serverless.ydb-lock-db.document_api_endpoint} \
        --profile ${var.aws_profile_user} \
        --region ${self.input.region}
    EOT
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      export AWS_ACCESS_KEY_ID=${self.input.access_key}
      export AWS_SECRET_ACCESS_KEY=${nonsensitive(self.input.secret_key)}

      aws dynamodb delete-table \
        --table-name ${self.input.table_name} \
        --endpoint ${self.input.doc_api_endpoint} \
        --region ${self.input.region}
    EOT
  }
}

resource "terraform_data" "tfstate_admin_setup" {
  # If bucket/path within bucket or ydb db/table make changes do it on your own
  triggers_replace = [
    local.tfstate_admin_keys.id,
    var.aws_profile_user,
  ]

  input = {
    aws_profile_user     = var.aws_profile_user
    aws_credentials_file = "~/.aws/credentials"
    aws_config_file      = "~/.aws/config"
    region               = var.ydb_region
  }

  provisioner "local-exec" {
    when       = create
    on_failure = continue
    command    = <<-EOT
      mkdir -p ${dirname(self.input.aws_credentials_file)}
      touch ${self.input.aws_credentials_file}
      touch ${self.input.aws_config_file}
      sed -i -e '/\[${var.aws_profile_user}\]/,+2d' ${self.input.aws_credentials_file}
      sed -i -e '/\[profile ${var.aws_profile_user}\]/,+1d' ${self.input.aws_config_file}

      cat <<EOF >> ${self.input.aws_credentials_file}
      [${var.aws_profile_user}]
      aws_access_key_id = ${local.tfstate_admin_keys.access_key}
      aws_secret_access_key = ${local.tfstate_admin_keys.secret_key}
      EOF

      cat <<EOF >> ${self.input.aws_config_file}
      [profile ${var.aws_profile_user}]
      region = ${self.input.region}
      EOF
    EOT
  }

  provisioner "local-exec" {
    when       = destroy
    on_failure = continue
    command    = <<EOT
      sed -i -e '/\[${self.input.aws_profile_user}\]/,+2d' ${self.input.aws_credentials_file}
      sed -i -e '/\[profile ${self.input.aws_profile_user}\]/,+1d' ${self.input.aws_config_file}
    EOT
  }
}
