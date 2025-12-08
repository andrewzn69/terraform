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

output "kubeconfig" {
  value       = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  description = "Kubernetes cluster configuration"
  sensitive   = true
}

output "controlplane_private_ips" {
  value       = [for inst in oci_core_instance.controlplane : inst.private_ip]
  description = "Private IPs of controlplane nodes"
}

output "controlplane_public_ips" {
  value       = [for inst in oci_core_instance.controlplane : inst.public_ip]
  description = "Public IPs of controlplane nodes"
}

output "worker_private_ips" {
  value       = [for inst in oci_core_instance.worker : inst.private_ip]
  description = "Private IPs of worker nodes"
}

output "worker_public_ips" {
  value       = [for inst in oci_core_instance.worker : inst.public_ip]
  description = "Public IPs of worker nodes"
}

output "controlplane_instance_ids" {
  value       = [for inst in oci_core_instance.controlplane : inst.id]
  description = "Instance IDs of controlplane nodes"
}

output "worker_instance_ids" {
  value       = [for inst in oci_core_instance.worker : inst.id]
  description = "Instance IDs of worker nodes"
}
