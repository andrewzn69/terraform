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

  values = [file("${path.root}/values/cilium.yaml")]

  set = [
    {
      name  = "k8sServiceHost"
      value = split(":", module.oke.cluster_endpoint)[0]
    },
    {
      name  = "k8sServicePort"
      value = split(":", module.oke.cluster_endpoint)[1]
    }
  ]

  depends_on = [module.oke]
}
