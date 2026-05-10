# outputs.tf

output "kubeconfig_raw" {
  description = "Raw kubeconfig YAML for connecting to the cluster"
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "Structured kubeconfig for provider configuration"
  value = {
    host                   = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  }
  sensitive = true
}

output "talosconfig" {
  description = "Talosconfig YAML for connecting via talosctl"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "bootstrap_endpoint" {
  description = "IP of the first control plane node"
  value       = local.bootstrap_endpoint
}
