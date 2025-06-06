resource "yandex_storage_bucket" "tfstate" {
  access_key = local.tfstate_admin_keys.access_key
  secret_key = local.tfstate_admin_keys.secret_key
  bucket     = var.tfstate_s3_bucket_name
  max_size   = local.GiB

  policy = templatefile("${path.module}/policy.json.tftpl", {
    bucket_name  = var.tfstate_s3_bucket_name
    bucket_admin = yandex_iam_service_account.tfstate_manager.id
    bucket_users = local.state_user_ids
    envs         = var.envs
  })

  versioning {
    enabled = var.versioning.is_enabled
  }

  lifecycle_rule {
    id      = "cleanupoldversions"
    enabled = var.versioning.has_lifecycle && var.versioning.is_enabled
    noncurrent_version_expiration {
      days = var.versioning.retention
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tfstate_symmetric_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
