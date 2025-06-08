resource "yandex_lockbox_secret" "rabbitmq" {
  name        = "Rabbitmq"
  description = "Password for RabbitMQ pretix user"

  password_payload_specification {
    include_digits      = true
    include_lowercase   = true
    include_punctuation = true
    include_uppercase   = true
    length              = 20
    password_key        = "somepasswordformq"
  }
}

resource "yandex_lockbox_secret" "ansible_vault_1" {
  name        = "[Ansible] Vault password"
  description = "Password for decrypt ansible-vault"
  labels = {
    "iac" = "ansible"
  }

  deletion_protection = true
}

resource "yandex_lockbox_secret" "postbox_api" {
  name        = "[API Key SMTP Postbox]"
  description = "Used to connect to Postbox"
}

resource "yandex_lockbox_secret" "grafana_admin" {
  name        = "[Monitoring] Grafana Web-UI admin password"
  description = "Password for user admin"
  labels = {
    "monitoring" = "grafana"
  }
}

resource "yandex_lockbox_secret" "postgre_1" {
  name        = "[Backend] PostgreSQL user pretix password"
  description = "Password for user pretix "
  labels = {
    "backend" = "postgres"
  }
}

resource "yandex_lockbox_secret" "gtilab_runner_shell" {
  name        = "Gitlab Runner"
  description = "Contains secrets to deploy runners on different platforms and stages"
}
