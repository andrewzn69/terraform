# proxmox-k8s-cluster

Terraform module for provisioning Kubernetes cluster VMs on Proxmox VE.

This module can:
- download the OS ISO to each Proxmox node
- create control plane and worker VMs
- set up VM network configuration through cloud-init.

## Requirements

- Proxmox VE with at least one node provisioned.
- API token created with sufficient permissions to create VMs and download ISOs.
- Network bridge configured on each target Proxmox node (e.g. `vmbr0`).
- Storage pools configured on each target Proxmox node (e.g. `local-lvm` for VM disks, `local` for cloud-init drives).
- Target nodes reachable from the machine running Terraform.
- Terraform ~> 1.15.
- bpg/proxmox ~> 0.106.0.

## Usage

```hcl
terraform {
  required_version = "~> 1.15"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.106.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://10.0.0.50:8006"
  api_token = "terraform@pam!example=a1b2c3d4-e5f6-7890-abcd-ef1234567890"
  insecure  = true
}

module "k8s_cluster" {
  source = "github.com/andrewzn69/terraform/modules/proxmox/proxmox-k8s-cluster"

  iso_url          = "https://example.com/os.iso"
  iso_datastore_id = "local"

  gateway_ip  = "10.0.0.1"
  node_subnet = "10.0.0.0/24"

  control_plane_groups = [
    {
      name              = "controlplane"
      node_name         = "proxmox"
      count             = 1
      vm_id_start       = 101
      ip_range_start    = 10
      cpu               = 2
      memory            = 4096
      disk_size         = 20
      storage           = "local-lvm"
      cloudinit_storage = "local-lvm"
      bridge            = "vmbr0"
    }
  ]

  worker_groups = [
    {
      name              = "worker"
      node_name         = "proxmox"
      count             = 2
      vm_id_start       = 201
      ip_range_start    = 11
      cpu               = 2
      memory            = 8192
      disk_size         = 30
      storage           = "local-lvm"
      cloudinit_storage = "local-lvm"
      bridge            = "vmbr0"
      data_disk_size    = 100
      data_storage      = "local-lvm"
    }
  ]
}
```

## Examples

See the [examples](./examples/) directory for complete working configurations.

<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->
