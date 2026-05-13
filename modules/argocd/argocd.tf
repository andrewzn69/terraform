# argocd.tf

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
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  timeout          = 600

  values = [local.values]

  lifecycle {
    ignore_changes = all
  }
}
