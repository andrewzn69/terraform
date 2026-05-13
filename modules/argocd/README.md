# argocd

Terraform module for installing ArgoCD on a Kubernetes cluster via Helm.

This module can:
- install ArgoCD with sane defaults
- use built-in default values, a custom values string, or fetch values from a remote URL

## Requirements

- Terraform ~> 1.15
- hashicorp/helm ~> 3.0
- hashicorp/http ~> 3.0
- Helm provider configured with cluster credentials

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = "<cluster-host>"
    client_certificate     = "<client-certificate>"
    client_key             = "<client-key>"
    cluster_ca_certificate = "<cluster-ca-certificate>"
  }
}

module "argocd" {
  source = "github.com/andrewzn69/terraform//modules/argocd"

  argocd_version = "<argocd-chart-version>"
}
```
## Examples

See the [examples](./examples/) directory for complete working configurations.
