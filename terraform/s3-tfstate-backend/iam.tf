data "yandex_iam_service_account" "admin_sa" {
  name      = var.admin_sa_name
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "tfstate_manager" {
  name      = "tfstate-s3-storage-admin"
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "tfstate_uploader" {
  name      = "tfstate-s3-uploader-compute-editor"
  folder_id = var.folder_id
}


/*
  Set roles and permissions for service accounts
*/

resource "yandex_resourcemanager_folder_iam_member" "tfstate_s3_sa_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.tfstate_manager.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "tfstate_s3_sa_uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"
  member    = "serviceAccount:${yandex_iam_service_account.tfstate_uploader.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "tfstate_s3_sa_uploader_editor" {
  folder_id = var.folder_id
  role      = "compute.editor"
  member    = "serviceAccount:${yandex_iam_service_account.tfstate_uploader.id}"
}

/*
  Set access keys for storage admin
*/

resource "yandex_iam_service_account_static_access_key" "tfstorage_admin_static_key" {
  service_account_id = yandex_iam_service_account.tfstate_manager.id
  description        = "Static access key for admin of S3"
}
