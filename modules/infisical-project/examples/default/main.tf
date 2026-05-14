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
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}

module "project" {
  source = "../../"

  org_id        = var.org_id
  identity_name = var.identity_name
  project_name  = var.project_name
  project_slug  = var.project_slug
  folders       = var.folders
}
