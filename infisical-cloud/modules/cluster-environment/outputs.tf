output "identity_id" {
  description = "The ID of the created identity"
  value       = infisical_identity.cluster.id
}

output "client_id" {
  description = "Client ID for Kubernetes operator authentication"
  value       = infisical_identity_universal_auth_client_secret.cluster.client_id
  sensitive   = true
}

output "client_secret" {
  description = "Client secret for Kubernetes operator authentication"
  value       = infisical_identity_universal_auth_client_secret.cluster.client_secret
  sensitive   = true
}

output "folder_id" {
  description = "The ID of the cluster-specific folder"
  value       = infisical_secret_folder.cluster.id
}
