# talos-cilium

Terraform module for installing Cilium CNI on a Talos Linux cluster via Helm.

This module can:
- install Cilium with all Talos-required values baked in
- use built-in default values, a custom values string, or fetch values from a remote url

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

module "talos_cilium" {
  source = "github.com/andrewzn69/terraform//modules/talos-cilium"

  cilium_version = "<cilium_version>"
}
```
## Examples

See the [examples](./examples/) directory for complete working configurations.
