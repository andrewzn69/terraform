# talos-cluster

Terraform module for bootstrapping a Talos Linux Kubernetes cluster from existing nodes.

This module can:
- generate a Talos image schematic with optional extensions
- generate and apply machine configuration to control plane and worker nodes
- bootstrap the cluster
- output kubeconfig and talosconfig

## Requirements

- Nodes provisioned and booted from a Talos ISO
- Terraform ~> 1.15
- siderolabs/talos ~> 0.11.0

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.11.0"
    }
  }
}

provider "talos" {}

module "talos_cluster" {
  source = "github.com/andrewzn69/terraform/modules/talos-cluster"

  control_plane_ips = ["<control-plane-ip>"]
  worker_ips        = ["<worker-ip>"]
  talos_version     = "<talos-version>"
  cluster_name      = "<cluster-name>"
  cluster_endpoint  = "https://<control-plane-ip>:6443"
  node_subnet       = "<subnet-cidr>"
}
```

## Examples

See the [examples](./examples/) directory for complete working configurations.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
