output "terraria_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.terraria.name
  description = "Name of the terraria backend set"
}

output "terraria_listener_name" {
  value       = oci_network_load_balancer_listener.terraria.name
  description = "Name of the terraria listener"
}
