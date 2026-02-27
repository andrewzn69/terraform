# versions.tf - terraform version, hcp backend, provider requirements

terraform {
  required_version = ">=1.14.0"

  cloud {
    organization = "zemn"

    workspaces {
      name = "oracle-talos-prod"
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.3.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
  }
}
