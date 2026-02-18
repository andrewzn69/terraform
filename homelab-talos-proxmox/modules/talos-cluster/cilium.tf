data "helm_template" "cilium" {
  name         = "cilium"
  repository   = "https://helm.cilium.io/"
  chart        = "cilium"
  namespace    = "kube-system"
  version      = var.cilium_version
  kube_version = var.kubernetes_version

  values = [file("${path.module}/values/cilium.yaml")]
}
