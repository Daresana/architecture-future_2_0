output "vm_id" {
  description = "Идентификатор VM"
  value       = yandex_compute_instance.pilot.id
}

output "internal_ip" {
  description = "Внутренний адрес VM"
  value       = yandex_compute_instance.pilot.network_interface[0].ip_address
}

output "external_ip" {
  description = "Внешний адрес для SSH"
  value       = yandex_compute_instance.pilot.network_interface[0].nat_ip_address
}

output "subnet_id" {
  description = "Идентификатор подсети"
  value       = yandex_vpc_subnet.pilot.id
}
