module "storage" {
  source = "../../modules/storage"

  compartment_id    = var.compartment_id
  bucket_name       = var.bucket_name
  namespace         = var.namespace
  image_object_name = var.image_object_name
  image_source_path = var.image_source_path
}

module "network" {
  source = "../../modules/network"

  compartment_id    = var.compartment_id
  vcn_cidr_blocks   = var.vcn_cidr_blocks
  subnet_cidr_block = var.subnet_cidr_block
}

module "compute" {
  source = "../../modules/compute"

  # cluster config
  cluster_name               = var.cluster_name
  talos_version              = var.talos_version
  talos_factory_schematic_id = var.talos_factory_schematic_id
  tailscale_auth_key         = var.tailscale_auth_key
  cluster_endpoint           = "https://${module.network.network_load_balancer_ip_addresses[0].ip_address}:6443"
  load_balancer_ip           = module.network.network_load_balancer_ip_addresses[0].ip_address

  # infra
  compartment_id = var.compartment_id
  subnet_id      = module.network.subnet_id
  subnet_cidr    = var.subnet_cidr_block

  # custom image
  custom_image_id = module.storage.custom_image_id

  # controlplane pool
  controlplane_count          = var.controlplane_count
  controlplane_memory_gb      = var.controlplane_memory_gb
  controlplane_ocpus          = var.controlplane_ocpus
  controlplane_base_ip_offset = var.controlplane_base_ip_offset

  # worker pool
  worker_count               = var.worker_count
  worker_memory_gb           = var.worker_memory_gb
  worker_ocpus               = var.worker_ocpus
  worker_base_ip_offset      = var.worker_base_ip_offset
  worker_boot_volume_size_gb = var.worker_boot_volume_size_gb

  # load balancer backend registration
  network_load_balancer_id      = module.network.network_load_balancer_id
  talos_backend_set_name        = module.network.talos_backend_set_name
  controlplane_backend_set_name = module.network.controlplane_backend_set_name
}

module "game_servers" {
  source = "../../modules/game-servers"

  compartment_id           = var.compartment_id
  network_load_balancer_id = module.network.network_load_balancer_id
  worker_instance_ids      = module.compute.worker_instance_ids
}
