/*
  Docs: https://yandex.cloud/en/docs/kms/security/
*/

resource "yandex_kms_symmetric_key" "tfstate_symmetric_key" {
  name              = "s3-tfstate-sse-key"
  folder_id         = var.folder_id
  description       = "Terraform backend S3 state SSE symmetric key"
  default_algorithm = "AES_192" # AES_128 AES_256 AES_256_HSM
  rotation_period   = "8760h"   // equal to 1 year
}

resource "yandex_resourcemanager_folder_iam_member" "kms_storage_user_sa" {
  count     = length(local.state_user_ids)
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${local.state_user_ids[count.index]}"
}

# resource "yandex_resourcemanager_folder_iam_member" "kms_storage_admin_sa" {
#   folder_id = var.folder_id
#   role      = "kms.keys.encrypterDecrypter"
#   member    = "serviceAccount:${yandex_iam_service_account.tfstate_manager.id}"
# }
