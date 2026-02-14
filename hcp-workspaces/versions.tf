# versions.tf - terraform version, hcp backend, provider requirements

terraform {
  required_version = ">=1.14.0"

  cloud {
    organization = "zemn"

    workspaces {
      name = "hcp-workspaces"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.74.0"
    }
  }
}
