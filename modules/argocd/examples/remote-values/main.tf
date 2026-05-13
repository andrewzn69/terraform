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

module "argocd" {
  source = "../../"

  argocd_version = var.argocd_version
  values_url     = var.values_url
}
