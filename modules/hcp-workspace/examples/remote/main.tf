terraform {
  required_version = "~> 1.15"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.76.0"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}

module "workspace" {
  source = "../../"

  name                       = "my-workspace"
  organization               = var.organization
  working_directory          = "envs/prod"
  trigger_prefixes           = ["my-project/"]
  vcs_repo_identifier        = var.vcs_repo_identifier
  github_app_installation_id = var.github_app_installation_id
  execution_mode             = "remote"

  variables = {
    environment  = { value = "prod" }
    secret_token = { value = "", sensitive = true }
  }
}
