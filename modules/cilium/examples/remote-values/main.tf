terraform {
  required_version = "~> 1.15"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = var.kubernetes_host
    client_certificate     = var.kubernetes_client_certificate
    client_key             = var.kubernetes_client_key
    cluster_ca_certificate = var.kubernetes_cluster_ca_certificate
  }
}

module "cilium" {
  source = "../../"

  cilium_version = var.cilium_version
  cluster_type   = var.cluster_type
  values_url     = var.values_url
}
