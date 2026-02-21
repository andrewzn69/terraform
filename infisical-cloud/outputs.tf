output "vizima_identity_id" {
  description = "Vizima cluster identity ID"
  value       = module.vizima.identity_id
}

output "vizima_client_id" {
  description = "Vizima cluster client ID for Kubernetes operator"
  value       = module.vizima.client_id
  sensitive   = true
}

output "vizima_client_secret" {
  description = "Vizima cluster client secret for Kubernetes operator"
  value       = module.vizima.client_secret
  sensitive   = true
}

output "project_id" {
  description = "Infisical project ID"
  value       = infisical_project.kubernetes.id
}

output "project_slug" {
  description = "Infisical project slug"
  value       = infisical_project.kubernetes.slug
}
