output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = oci_containerengine_cluster.main.id
}

output "cluster_endpoint" {
  description = "Public endpoint of the OKE cluster"
  value       = oci_containerengine_cluster.main.endpoints[0].public_endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for the OKE cluster"
  value       = data.oci_containerengine_cluster_kube_config.main.content
  sensitive   = true
}
