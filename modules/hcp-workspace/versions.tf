# versions.tf

terraform {
  required_version = "~> 1.15"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.76.0"
    }
  }
}
