# cilium.tf

resource "terraform_data" "validate" {
  lifecycle {
    precondition {
      condition     = !(var.values_local != null && var.values_url != null)
      error_message = "Only one of values_local or values_url can be set, not both."
    }
  }
}

data "http" "values" {
  count = var.values_url != null ? 1 : 0
  url   = var.values_url
}

locals {
  values = (
    var.values_url != null ? data.http.values[0].response_body :
    var.values_local != null ? var.values_local :
    file("${path.module}/values.yaml")
  )

  endpoint_parts = split(":", trimprefix(var.cluster_endpoint, "https://"))
  endpoint_host  = local.endpoint_parts[0]
  endpoint_port  = local.endpoint_parts[1]
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

  values = [local.values]

  set = [{
    name  = "k8sServiceHost"
    value = local.endpoint_host
    }, {
    name  = "k8sServicePort"
    value = local.endpoint_port
  }]

  lifecycle {
    ignore_changes = all
  }
}
