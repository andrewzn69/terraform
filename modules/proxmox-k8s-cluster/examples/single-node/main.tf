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
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

module "k8s_cluster" {
  source = "../../"

  iso_url              = var.iso_url
  iso_datastore_id     = var.iso_datastore_id
  gateway_ip           = var.gateway_ip
  node_subnet          = var.node_subnet
  control_plane_groups = var.control_plane_groups
  worker_groups        = var.worker_groups
}
