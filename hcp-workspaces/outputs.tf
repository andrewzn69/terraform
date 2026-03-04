output "homelab_talos_prod_workspace_id" {
  description = "Workspace ID for homelab-talos-prod"
  value       = tfe_workspace.homelab_talos_prod.id
}

output "oracle_oke_prod_workspace_id" {
  description = "Workspace ID for oracle-oke-prod"
  value       = tfe_workspace.oracle_oke_prod.id
}

output "infisical_cloud_workspace_id" {
  description = "Workspace ID for infisical-cloud"
  value       = tfe_workspace.infisical_cloud.id
}

output "agent_pool_id" {
  description = "Agent pool ID for homelab"
  value       = tfe_agent_pool.homelab.id
}
