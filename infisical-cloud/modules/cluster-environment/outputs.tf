output "environment_slug" {
  description = "Environment slug for this cluster"
  value       = infisical_project_environment.this.slug
}

output "identity_id" {
  description = "Machine identity ID"
  value       = infisical_identity.k8s_operator.id
}

output "identity_client_id" {
  description = "Client ID for Kubernetes operator"
  value       = infisical_identity_universal_auth.k8s_operator.client_id
}

output "identity_client_secret" {
  description = "Client secret for Kubernetes operator"
  value       = infisical_identity_universal_auth_client_secret.k8s_operator.client_secret
  sensitive   = true
}
