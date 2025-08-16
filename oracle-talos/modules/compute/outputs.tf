output "controlplane_configuration" {
  value       = data.talos_machine_configuration.controlplane.machine_configuration
  description = "Generated controlplane machine configuration"
  sensitive   = true
}

output "worker_configuration" {
  value       = data.talos_machine_configuration.worker.machine_configuration
  description = "Generated worker machine configuration"
  sensitive   = true
}

output "client_configuration" {
  value       = data.talos_client_configuration.this.talos_config
  description = "Generated client configuration (talosconfig)"
  sensitive   = true
}

output "cluster_name" {
  value       = var.cluster_name
  description = "Cluster name"
}

output "cluster_endpoint" {
  value       = var.cluster_endpoint
  description = "Cluster endpoint"
}
