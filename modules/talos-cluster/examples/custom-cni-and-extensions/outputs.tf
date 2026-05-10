output "kubeconfig_raw" {
  description = "Raw kubeconfig YAML for connecting to the cluster"
  value       = module.talos_cluster.kubeconfig_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "Structured kubeconfig for provider configuration"
  value       = module.talos_cluster.kubeconfig
  sensitive   = true
}

output "talosconfig" {
  description = "Talosconfig YAML for connecting via talosctl"
  value       = module.talos_cluster.talosconfig
  sensitive   = true
}

output "bootstrap_endpoint" {
  description = "IP of the first control plane node"
  value       = module.talos_cluster.bootstrap_endpoint
}
