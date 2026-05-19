# hcp-workspace

Terraform module for creating and configuring HCP Terraform workspaces.

This module can:
- create a workspace with optional VCS integration via GitHub App
- run plans on a self-hosted agent pool, HCP's remote runners, or locally
- create workspace variables, with sensitive variables left empty for manual entry in the HCP UI

## Requirements

- HCP Terraform organization with an API token.
- GitHub App installed on the repository if using VCS integration.
- Terraform ~> 1.15.
- hashicorp/tfe ~> 0.76.0.

## Usage

```hcl
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
  token = "exampl.atlasv1.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQR"
}

module "workspace" {
  source = "github.com/andrewzn69/terraform//modules/hcp-workspace"

  name                       = "my-workspace"
  organization               = "my-org"
  working_directory          = "envs/prod"
  trigger_prefixes           = ["my-project/"]
  vcs_repo_identifier        = "my-org/my-repo"
  github_app_installation_id = "12345678"
  execution_mode             = "agent"
  agent_pool_id              = "apool-yoGUFz5zcRMMz53i"

  variables = {
    environment  = { value = "prod" }
    secret_token = { value = "", sensitive = true }
  }

  variable_set_ids = ["varset-pLmKj8nQrVxWzY2s"]
}
```

## Examples

See the [examples](./examples/) directory for complete working configurations.
