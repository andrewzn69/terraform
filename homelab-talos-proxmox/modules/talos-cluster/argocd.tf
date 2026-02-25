# argocd.tf - argocd installation and configuration

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  timeout          = 600

  values = [file("${path.module}/values/argocd.yaml")]

  depends_on = [helm_release.cilium]
}

# configure argocd provider
provider "argocd" {
  server_addr = "${local.control_plane_private_ipv4_list[0]}:30080"
  plain_text  = true # http for bootstrap phase
  insecure    = true # skip tls verification
}

# add kubernetes repo with gh app auth
resource "argocd_repository" "kubernetes" {
  repo                      = "https://github.com/andrewzn69/kubernetes"
  type                      = "git"
  githubapp_id              = var.github_app_id
  githubapp_installation_id = var.github_app_installation_id
  githubapp_private_key     = var.github_app_private_key

  depends_on = [helm_release.argocd]
}
