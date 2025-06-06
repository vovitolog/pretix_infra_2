resource "yandex_vpc_network" "dev-network" {
  name        = "default"
  description = "Auto-created network"
}

resource "yandex_vpc_subnet" "a-subnet" {
  network_id     = yandex_vpc_network.dev-network.id
  zone           = "ru-central1-a"
  v4_cidr_blocks = ["10.128.0.0/24"]
  description    = "Auto-created default subnet for zone ru-central1-a in default"
}

resource "yandex_vpc_subnet" "b-subnet" {
  network_id     = yandex_vpc_network.dev-network.id
  zone           = "ru-central1-b"
  v4_cidr_blocks = ["10.129.0.0/24"]
  description    = "Auto-created default subnet for zone ru-central1-b in default"
}

resource "yandex_vpc_subnet" "d-subnet" {
  network_id     = yandex_vpc_network.dev-network.id
  zone           = "ru-central1-d"
  v4_cidr_blocks = ["10.130.0.0/24"]
  description    = "Auto-created default subnet for zone ru-central1-d in default"
}
