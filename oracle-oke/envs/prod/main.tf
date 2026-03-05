# main.tf - production environment configuration for oracle oke cluster
# creates network infrastructure and oke cluster with cilium cni

# create vcn, subnets, security lists, and routing for the cluster
module "network" {
  source = "../../modules/network"

  compartment_id             = var.compartment_id
  cluster_name               = var.cluster_name
  vcn_cidr_block             = var.vcn_cidr_block
  endpoint_subnet_cidr_block = var.endpoint_subnet_cidr_block
  nodes_subnet_cidr_block    = var.nodes_subnet_cidr_block
}

# create oke cluster, node pool, block volumes, and deploy cilium
module "oke" {
  source = "../../modules/oke"

  compartment_id     = var.compartment_id
  cluster_name       = var.cluster_name
  vcn_id             = module.network.vcn_id
  endpoint_subnet_id = module.network.endpoint_subnet_id
  nodes_subnet_id    = module.network.nodes_subnet_id

  kubernetes_version       = var.kubernetes_version
  node_count               = var.node_count
  node_ocpus               = var.node_ocpus
  node_memory_gb           = var.node_memory_gb
  node_boot_volume_size_gb = var.node_boot_volume_size_gb

  pods_cidr     = var.pods_cidr
  services_cidr = var.services_cidr

  cilium_version     = var.cilium_version
  tailscale_auth_key = var.tailscale_auth_key
  ssh_public_key     = var.ssh_public_key
}
