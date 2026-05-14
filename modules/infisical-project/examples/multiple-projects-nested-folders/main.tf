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
  source   = "../../"
  for_each = var.projects

  org_id        = var.org_id
  identity_name = each.key
  project_name  = each.value.project_name
  project_slug  = each.value.project_slug
  folders       = each.value.folders
}
