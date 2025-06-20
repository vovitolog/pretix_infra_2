data "yandex_vpc_subnet" "development" {
  name      = "development"
  folder_id = var.folder_id
}
