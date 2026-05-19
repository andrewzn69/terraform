# cilium

Terraform module for installing Cilium CNI on a Kubernetes cluster via Helm.

This module can:
- install Cilium with platform-specific default values
- use built-in default values, a custom values string, or fetch values from a remote URL

## Requirements

- Terraform ~> 1.15
- hashicorp/helm ~> 3.1.1
- hashicorp/http ~> 3.6.0
- Helm provider configured with cluster credentials

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.1"
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

module "cilium" {
  source = "github.com/andrewzn69/terraform//modules/cilium"

  cilium_version = "<cilium-version>"
  cluster_type   = "<talos|oke>"
}
```

## Supported Cluster Types

| `cluster_type` | Default values preset | Notes |
| -------------- | --------------------- | ----- |
| `talos`        | `values/talos.yaml`   | Includes Talos-specific cgroup, capability, and DNS settings |
| `oke`          | `values/oke.yaml`     | Requires `cluster_endpoint`. Sets `k8sServiceHost` and `k8sServicePort` automatically |

## Examples

See the [examples](./examples/) directory for complete working configurations.
