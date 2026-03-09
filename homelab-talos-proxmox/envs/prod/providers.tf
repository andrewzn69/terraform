# providers.tf - provider configuration for proxmox, helm, kubernetes, and argocd

provider "proxmox" {
  endpoint  = "https://${var.proxmox_host_ip}:8006/"
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
  insecure  = true
}

# parse kubeconfig from module output for provider configuration
locals {
  kube_config = try({
    host                   = module.talos_cluster.kubeconfig.host
    client_certificate     = module.talos_cluster.kubeconfig.client_certificate
    client_key             = module.talos_cluster.kubeconfig.client_key
    cluster_ca_certificate = module.talos_cluster.kubeconfig.cluster_ca_certificate
  }, null)
}

data "kubernetes_secret_v1" "argocd_initial_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
}

provider "helm" {
  kubernetes = local.kube_config != null ? {
    host                   = local.kube_config.host
    client_certificate     = local.kube_config.client_certificate
    client_key             = local.kube_config.client_key
    cluster_ca_certificate = local.kube_config.cluster_ca_certificate
  } : null
}

provider "kubernetes" {
  host                   = try(local.kube_config.host, null)
  client_certificate     = try(local.kube_config.client_certificate, null)
  client_key             = try(local.kube_config.client_key, null)
  cluster_ca_certificate = try(local.kube_config.cluster_ca_certificate, null)
}

provider "argocd" {
  port_forward_with_namespace = "argocd"
  plain_text                  = true
  username                    = "admin"
  password                    = try(data.kubernetes_secret_v1.argocd_initial_password.data["password"], null)

  kubernetes {
    host                   = try(local.kube_config.host, null)
    client_certificate     = try(local.kube_config.client_certificate, null)
    client_key             = try(local.kube_config.client_key, null)
    cluster_ca_certificate = try(local.kube_config.cluster_ca_certificate, null)
  }
}
