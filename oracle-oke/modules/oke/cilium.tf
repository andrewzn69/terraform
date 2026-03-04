# cilium.tf - deploys cilium cni to replace flannel

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

  # split cluster endpoint url into host and port for cilium config
  set = [
    {
      name  = "k8sServiceHost"
      value = split(":", oci_containerengine_cluster.main.endpoints[0].kubernetes)[0]
    },
    {
      name  = "k8sServicePort"
      value = split(":", oci_containerengine_cluster.main.endpoints[0].kubernetes)[1]
    }
  ]

  depends_on = [oci_containerengine_node_pool.workers]
}
