output "homelab_identity_client_id" {
  description = "Kubernetes operator client ID for homelab cluster"
  value       = module.homelab_env.identity_client_id
}

output "homelab_identity_client_secret" {
  description = "Kubernetes operator client secret for homelab cluster"
  value       = module.homelab_env.identity_client_secret
  sensitive   = true
}

# TODO: setup oracle
# output "oracle_identity_client_id" {
#   description = "Kubernetes operator client ID for oracle cluster"
#   value       = module.oracle_env.identity_client_id
# }
#
# output "oracle_identity_client_secret" {
#   description = "Kubernetes operator client secret for oracle cluster"
#   value       = module.oracle_env.identity_client_secret
#   sensitive   = true
# }
