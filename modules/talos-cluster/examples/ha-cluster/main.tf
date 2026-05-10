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
  source = "../../"

  control_plane_ips = var.control_plane_ips
  worker_ips        = var.worker_ips
  talos_version     = var.talos_version
  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  node_subnet       = var.node_subnet
}
