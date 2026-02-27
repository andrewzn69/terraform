# --- storage ---

output "custom_image_id" {
  description = "OCID of the custom Talos image"
  value       = module.storage.custom_image_id
}

# --- network ---

output "network_load_balancer_ip" {
  description = "Public IP of the network load balancer"
  value       = module.network.network_load_balancer_ip_addresses[0].ip_address
}

output "subnet_id" {
  description = "OCID of the subnet"
  value       = module.network.subnet_id
}

# --- compute ---

output "kubeconfig" {
  description = "Kubernetes cluster configuration"
  value       = module.compute.kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talos client configuration"
  value       = module.compute.client_configuration
  sensitive   = true
}

output "controlplane_private_ips" {
  description = "Private IPs of controlplane nodes"
  value       = module.compute.controlplane_private_ips
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value       = module.compute.worker_private_ips
}
