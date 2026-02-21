output "vizima_project_id" {
  description = "Vizima project ID"
  value       = module.vizima.project_id
}

output "vizima_project_slug" {
  description = "Vizima project slug"
  value       = module.vizima.project_slug
}

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
