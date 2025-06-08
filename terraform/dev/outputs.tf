output "dev_singleton_ip" {
  description = "Public IP address of the Dev instance"
  value       = try(yandex_compute_instance.dev_singleton.network_interface[0].nat_ip_address, null)
}
