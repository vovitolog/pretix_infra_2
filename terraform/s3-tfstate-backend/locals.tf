locals {
  state_user_ids = [
    data.yandex_iam_service_account.admin_sa.id,
    yandex_iam_service_account.tfstate_uploader.id
  ]

  tfstate_admin_keys = yandex_iam_service_account_static_access_key.tfstorage_admin_static_key

  GiB = 1073741824 # 1 GiB
}
