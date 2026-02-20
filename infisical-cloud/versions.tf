terraform {
  required_version = ">=1.14.0"

  cloud {
    organization = "zemn"

    workspaces {
      name = "infisical-cloud"
    }
  }

  required_providers {
    infisical = {
      source  = "infisical/infisical"
      version = "~> 0.16"
    }
  }
}
