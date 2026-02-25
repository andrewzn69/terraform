# providers.tf - provider configurations for helm, kubernetes and argocd

provider "helm" {
  kubernetes = {
    host                   = talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.host
  client_certificate     = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this[0].kubernetes_client_configuration.ca_certificate)
}

provider "argocd" {
  server_addr = "${local.control_plane_private_ipv4_list[0]}:30080"
  plain_text  = true # http for bootstrap phase
  insecure    = true # skip tls verification
}
