# outputs.tf

output "client_id" {
  description = "Client ID for the machine identity"
  value       = infisical_identity_universal_auth_client_secret.this.client_id
  sensitive   = true
}

output "client_secret" {
  description = "Client secret for the machine identity"
  value       = infisical_identity_universal_auth_client_secret.this.client_secret
  sensitive   = true
}

output "environment_slug" {
  description = "Environment slug used to create folders"
  value       = var.environment_slug
}

output "project_id" {
  description = "Infisical project ID"
  value       = infisical_project.this.id
}
