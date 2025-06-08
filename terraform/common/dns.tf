resource "yandex_dns_zone" "pretix" {
  name = "pretix"

  zone             = "pretix.devops-factory.com."
  public           = true
  private_networks = []

  deletion_protection = false # imported, might be set to true
}

resource "yandex_dns_recordset" "pretix_gitlab" {
  zone_id = yandex_dns_zone.pretix.id
  name    = "gitlab.pretix.devops-factory.com."
  type    = "A"
  ttl     = 600
  data    = ["165.22.218.15"]
}

resource "yandex_dns_recordset" "post_dkim" {
  zone_id = yandex_dns_zone.pretix.id
  name    = "info._domainkey.pretix.devops-factory.com."
  type    = "TXT"
  ttl     = 600
  data    = ["\"v=DKIM1;h=sha256;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtTk3Rcuy1Ha3ZtvvcKMDzfYora6k4a/Zs+VyqQBBC3synDnKqpndh3Ktw0wN/iSv4/AMdOg/+OBQIdmmMkUMkbMV1BVUt+E18WQvLUVNtu5Yr2vZqM9X+0jeOLC8IOIT3/nUe/j03V7uV2tctuhccXWLod+co1iMZev6UwpikB4nCKnNF8kQSrw3Y9\" \"LIOCm4OQRInIwLdKBqXOSZkUk0l3pGbQoLXNBNlsprIRzac9dG5QUO8/N0lSTul4IonDxBVkyISCbnLdnSaPtDiVYgTSwhqkWXpeDUp1q9ep3qO3vgGHEWQ6dPaMPddYipfCST2e0Ewd9mvpGQBu8alxY/+QIDAQAB\""]
}

resource "yandex_dns_recordset" "mvp_instance" {
  zone_id = yandex_dns_zone.pretix.id
  name    = "mvp.pretix.devops-factory.com."
  type    = "A"
  ttl     = 600
  data    = ["158.160.165.67"]
}

resource "yandex_dns_recordset" "nameservers" {
  zone_id = yandex_dns_zone.pretix.id
  name    = "pretix.devops-factory.com."
  type    = "NS"
  ttl     = 3600
  data    = ["ns1.yandexcloud.net.", "ns2.yandexcloud.net."]
}

resource "yandex_dns_recordset" "zone_soa" {
  zone_id = yandex_dns_zone.pretix.id
  name    = "pretix.devops-factory.com."
  type    = "SOA"
  ttl     = 3600
  data    = ["ns1.yandexcloud.net. mx.cloud.yandex.net. 1 10800 900 604800 900"]
}

resource "yandex_dns_recordset" "dev_singleton" {
  count   = local.dev.dev_singleton_ip == null ? 0 : 1
  zone_id = yandex_dns_zone.pretix.id
  name    = "dev.pretix.devops-factory.com."
  type    = "A"
  ttl     = 180
  data    = [local.dev.dev_singleton_ip]
}