# outputs.tf - values exposed by the talos-cluster module

output "kubeconfig_raw" {
  description = "Raw kubeconfig for connecting to the cluster"
  value       = talos_cluster_kubeconfig.this[0].kubeconfig_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "Structured kubeconfig for provider configuration"
  value = {
    host                   = talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.ca_certificate)
  }
  sensitive = true
}

output "talosconfig" {
  description = "Talosconfig for connecting via talosctl"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "control_plane_ips" {
  description = "Private IP addresses of control plane nodes"
  value       = local.control_plane_private_ipv4_list
}

output "bootstrap_endpoint" {
  description = "IP of the first control plane node used for bootstrapping"
  value       = local.bootstrap_endpoint
}
