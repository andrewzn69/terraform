# versions.tf - terraform version, hcp backend, provider requirements

terraform {
  required_version = ">=1.14.0"

  cloud {
    organization = "zemn"

    workspaces {
      name = "homelab-talos-prod"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.95.1-rc1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
  }
}
