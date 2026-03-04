# outputs.tf - user-facing outputs

output "kubeconfig" {
  description = "Kubeconfig YAML for connecting to the cluster"
  value       = module.talos_cluster.kubeconfig_raw
  sensitive   = true
}

output "talosconfig" {
  description = "Talosconfig YAML for connecting via talosctl"
  value       = module.talos_cluster.talosconfig
  sensitive   = true
}

output "control_plane_ips" {
  description = "Private IP addresses of control plane nodes"
  value       = module.talos_cluster.control_plane_ips
}
