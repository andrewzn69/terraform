module "talos_image" {
  source = "../../modules/talos-image"

  talos_version = var.talos_version
}

module "storage" {
  source = "../../modules/storage"

  compartment_id = var.compartment_id
  namespace      = var.namespace
  talos_version  = var.talos_version
  disk_image_url = module.talos_image.disk_image_url
}

module "network" {
  source = "../../modules/network"

  compartment_id             = var.compartment_id
  cluster_name               = var.cluster_name
  vcn_cidr_blocks            = var.vcn_cidr_blocks
  subnet_cidr_block          = var.subnet_cidr_block
  talos_listener_port        = var.talos_backend_port
  controlplane_listener_port = var.controlplane_backend_port
}

module "compute" {
  source = "../../modules/compute"

  # infra
  compartment_id = var.compartment_id
  subnet_id      = module.network.subnet_id
  subnet_cidr    = var.subnet_cidr_block

  # load balancer
  network_load_balancer_id      = module.network.network_load_balancer_id
  talos_backend_set_name        = module.network.talos_backend_set_name
  controlplane_backend_set_name = module.network.controlplane_backend_set_name

  # ports
  talos_backend_port        = var.talos_backend_port
  controlplane_backend_port = var.controlplane_backend_port

  # instance config
  instance_shape                       = var.instance_shape
  instance_launch_options_network_type = var.instance_launch_options_network_type
  boot_volume_size_gb                  = var.boot_volume_size_gb

  # image
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
  worker_data_volume_size_gb = var.worker_data_volume_size_gb

  # cluster config
  cluster_name        = var.cluster_name
  talos_version       = var.talos_version
  installer_image_url = module.talos_image.installer_url
  tailscale_auth_key  = var.tailscale_auth_key
  cluster_endpoint    = "https://${module.network.network_load_balancer_ip_addresses[0].ip_address}:6443"
  load_balancer_ip    = module.network.network_load_balancer_ip_addresses[0].ip_address
  cilium_version      = var.cilium_version

  # free tier limits
  free_tier_memory_limit     = var.free_tier_memory_limit
  free_tier_ocpu_limit       = var.free_tier_ocpu_limit
  free_tier_storage_limit_gb = var.free_tier_storage_limit_gb
}
