# providers.tf - provider configurations for helm, kubernetes and argocd

provider "helm" {
  kubernetes = {
    host                   = local.kube_config.host
    client_certificate     = local.kube_config.client_certificate
    client_key             = local.kube_config.client_key
    cluster_ca_certificate = local.kube_config.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = local.kube_config.host
  client_certificate     = local.kube_config.client_certificate
  client_key             = local.kube_config.client_key
  cluster_ca_certificate = local.kube_config.cluster_ca_certificate
}

provider "argocd" {
  port_forward_with_namespace = "argocd"
  plain_text                  = true # http for bootstrap phase
  username                    = "admin"
  password                    = data.kubernetes_secret_v1.argocd_initial_password.data["password"]

  kubernetes {
    host                   = local.kube_config.host
    client_certificate     = local.kube_config.client_certificate
    client_key             = local.kube_config.client_key
    cluster_ca_certificate = local.kube_config.cluster_ca_certificate
  }
}
