# wait for kubernetes api to be ready
data "kubernetes_nodes" "wait" {
  depends_on = [talos_cluster_kubeconfig.this]
}

resource "helm_release" "cilium" {
  name             = "cilium"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  namespace        = "kube-system"
  version          = var.cilium_version
  create_namespace = false
  wait             = true
  wait_for_jobs    = true
  timeout          = 600

  values = [file("${path.module}/values/cilium.yaml")]

  depends_on = [data.kubernetes_nodes.wait]
}
