# infisical-project

Terraform module for creating an Infisical project with a machine identity and folder structure.

This module can:
- create an Infisical project with a machine identity
- create a nested folder structure up to 2 levels deep (e.g. `folder/subfolder`)

## Requirements

- Terraform ~> 1.15
- infisical/infisical ~> 0.16.0

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16.0"
    }
  }
}

provider "infisical" {
  host = "https://eu.infisical.com"

  auth = {
    universal = {
      client_id     = "<client-id>"
      client_secret = "<client-secret>"
    }
  }
}

module "project" {
  source = "github.com/andrewzn69/terraform//modules/infisical-project"

  org_id        = "<org-id>"
  identity_name = "<identity-name>"
  project_name  = "My Project"
  project_slug  = "my-project"
  folders       = ["folder1", "folder2/subfolder"]
}
```

## Examples

See the [examples](./examples/) directory for complete working configurations.
