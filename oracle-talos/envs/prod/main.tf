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

  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${module.network.network_load_balancer_ip_addresses[0].ip_address}:6443"
  load_balancer_ip = module.network.network_load_balancer_ip_addresses[0].ip_address

  # basic infra
  compartment_id = var.compartment_id
  subnet_id      = module.network.subnet_id

  # custom image from storage module
  custom_image_id  = module.storage.custom_image_id
  object_bucket    = module.storage.bucket_name
  object_namespace = module.storage.bucket_namespace
  object_object    = module.storage.object_name

  # controlplane config
  controlplane_display_name = var.controlplane_display_name
  controlplane_private_ip   = var.controlplane_private_ip

  # worker config
  worker_display_name = var.worker_display_name
  worker_private_ip   = var.worker_private_ip

  # load balancer backend registration
  network_load_balancer_id      = module.network.network_load_balancer_id
  talos_backend_set_name        = module.network.talos_backend_set_name
  controlplane_backend_set_name = module.network.controlplane_backend_set_name
}
