# main.tf - prod env entry point

module "talos_cluster" {
  source = "../../modules/talos-cluster"

  # proxmox
  proxmox_host      = var.proxmox_host
  proxmox_storage   = var.proxmox_storage
  cloudinit_storage = var.cloudinit_storage
  proxmox_bridge    = var.proxmox_bridge

  # networking
  gateway_ip     = var.gateway_ip
  node_subnet    = var.node_subnet
  ip_range_start = var.ip_range_start

  # vms
  number_of_vms             = var.number_of_vms
  control_plane_vm_count    = var.control_plane_vm_count
  control_plane_vm_id_start = var.control_plane_vm_id_start
  worker_vm_id_start        = var.worker_vm_id_start
  control_plane_cpu         = var.control_plane_cpu
  control_plane_memory      = var.control_plane_memory
  control_plane_disk_size   = var.control_plane_disk_size
  worker_cpu                = var.worker_cpu
  worker_memory             = var.worker_memory
  worker_disk_size          = var.worker_disk_size
  worker_data_storage       = var.worker_data_storage
  worker_data_disk_size     = var.worker_data_disk_size

  # talos
  talos_version      = var.talos_version
  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  cluster_api_host   = var.cluster_api_host
  tailscale_auth_key = var.tailscale_auth_key
  cilium_version     = var.cilium_version

  # argocd
  github_app_id              = var.github_app_id
  github_app_installation_id = var.github_app_installation_id
  github_app_private_key     = var.github_app_private_key
}
