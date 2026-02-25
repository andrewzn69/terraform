terraform {
  required_version = ">=1.14.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.95.1-rc1"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.10.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.13.0"
    }
  }
}
