module "network" {
  source = "../../modules/network"

  compartment_id    = var.compartment_id
  cluster_name      = var.cluster_name
  vcn_cidr_block    = var.vcn_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "oke" {
  source = "../../modules/oke"

  compartment_id = var.compartment_id
  cluster_name   = var.cluster_name
  vcn_id         = module.network.vcn_id
  subnet_id      = module.network.subnet_id

  kubernetes_version        = var.kubernetes_version
  node_count                = var.node_count
  node_ocpus                = var.node_ocpus
  node_memory_gb            = var.node_memory_gb
  node_boot_volume_size_gb  = var.node_boot_volume_size_gb
  node_block_volume_size_gb = var.node_block_volume_size_gb

  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr

  tailscale_auth_key = var.tailscale_auth_key
  ssh_public_key     = var.ssh_public_key
}
