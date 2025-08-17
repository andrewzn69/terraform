# storage module outputs
output "bucket_name" {
  value = module.storage.bucket_name
}

output "bucket_namespace" {
  value = module.storage.bucket_namespace
}

output "image_object_name" {
  value = module.storage.object_name
}

output "image_object_source" {
  value = module.storage.object_url
}

output "bucket_id" {
  value = module.storage.bucket_id
}

output "custom_image_id" {
  value = module.storage.custom_image_id
}

output "object_url" {
  value = module.storage.object_url
}

# network module outputs
output "vcn_id" {
  value = module.network.vcn_id
}

output "vcn_cidr_blocks" {
  value = module.network.vcn_cidr_blocks
}

output "internet_gateway_id" {
  value = module.network.internet_gateway_id
}

output "route_table_id" {
  value = module.network.route_table_id
}

output "security_list_id" {
  value = module.network.security_list_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "subnet_cidr_block" {
  value = module.network.subnet_cidr_block
}

output "network_load_balancer_id" {
  value = module.network.network_load_balancer_id
}

output "network_load_balancer_ip_addresses" {
  value = module.network.network_load_balancer_ip_addresses
}

output "talos_backend_set_id" {
  value = module.network.talos_backend_set_id
}

output "talos_backend_set_name" {
  value = module.network.talos_backend_set_name
}

output "controlplane_backend_set_id" {
  value = module.network.controlplane_backend_set_id
}

output "controlplane_backend_set_name" {
  value = module.network.controlplane_backend_set_name
}

output "talos_listener_id" {
  value = module.network.talos_listener_id
}

output "controlplane_listener_id" {
  value = module.network.controlplane_listener_id
}

# compute module outputs
output "controlplane_configuration" {
  value     = module.compute.controlplane_configuration
  sensitive = true
}

output "worker_configuration" {
  value     = module.compute.worker_configuration
  sensitive = true
}

output "client_configuration" {
  value     = module.compute.client_configuration
  sensitive = true
}

output "cluster_name" {
  value = module.compute.cluster_name
}

output "cluster_endpoint" {
  value = module.compute.cluster_endpoint
}

output "kubeconfig" {
  value     = module.compute.kubeconfig
  sensitive = true
}
