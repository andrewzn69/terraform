# outputs.tf

output "workspace_id" {
  description = "ID of the workspace"
  value       = tfe_workspace.this.id
}

output "workspace_name" {
  description = "Name of the workspace"
  value       = tfe_workspace.this.name
}
