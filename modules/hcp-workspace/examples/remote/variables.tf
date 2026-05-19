variable "tfe_token" {
  description = "HCP Terraform API token"
  type        = string
  sensitive   = true
}

variable "organization" {
  description = "HCP Terraform organization name"
  type        = string
}

variable "vcs_repo_identifier" {
  description = "VCS repo identifier in the format org/repo"
  type        = string
}

variable "github_app_installation_id" {
  description = "GitHub App installation ID for VCS integration"
  type        = string
}
