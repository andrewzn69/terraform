output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = module.oke.cluster_id
}

output "cluster_endpoint" {
  description = "Public endpoint of the OKE cluster"
  value       = module.oke.cluster_endpoint
}

output "kubeconfig" {
  description = "Kubeconfig for the OKE cluster"
  value       = module.oke.kubeconfig
  sensitive   = true
}
