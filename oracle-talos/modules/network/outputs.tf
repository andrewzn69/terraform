output "vcn_id" {
  value       = oci_core_vcn.talos_vcn.id
  description = "OCID of the VCN"
}

output "vcn_cidr_blocks" {
  value       = oci_core_vcn.talos_vcn.cidr_blocks
  description = "CIDR blocks of the VCN"
}

output "internet_gateway_id" {
  value       = oci_core_internet_gateway.talos_internet_gateway.id
  description = "OCID of the internet gateway"
}

output "route_table_id" {
  value       = oci_core_route_table.talos_route_table.id
  description = "OCID of the route table"
}

output "security_list_id" {
  value       = oci_core_security_list.talos_security_list.id
  description = "OCID of the security list"
}

output "subnet_id" {
  value       = oci_core_subnet.talos_subnet.id
  description = "OCID of the subnet"
}

output "subnet_cidr_block" {
  value       = oci_core_subnet.talos_subnet.cidr_block
  description = "CIDR block of the subnet"
}

output "network_load_balancer_id" {
  value       = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  description = "OCID of the network load balancer"
}

output "network_load_balancer_ip_addresses" {
  value       = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.ip_addresses
  description = "IP addresses of the network load balancer"
}

output "talos_backend_set_id" {
  value       = oci_network_load_balancer_backend_set.talos_backend_set.id
  description = "OCID of the talos backend set"
}

output "talos_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.talos_backend_set.name
  description = "Name of the talos backend set"
}

output "controlplane_backend_set_id" {
  value       = oci_network_load_balancer_backend_set.controlplane_backend_set.id
  description = "OCID of the controlplane backend set"
}

output "controlplane_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.controlplane_backend_set.name
  description = "Name of the controlplane backend set"
}

output "talos_listener_id" {
  value       = oci_network_load_balancer_listener.talos_listener.id
  description = "OCID of the talos listener"
}

output "controlplane_listener_id" {
  value       = oci_network_load_balancer_listener.controlplane_listener.id
  description = "OCID of the controlplane listener"
}

output "minecraft_backend_set_id" {
  value       = oci_network_load_balancer_backend_set.minecraft_backend_set.id
  description = "OCID of the minecraft backend set"
}

output "minecraft_backend_set_name" {
  value       = oci_network_load_balancer_backend_set.minecraft_backend_set.name
  description = "Name of the minecraft backend set"
}

output "minecraft_listener_id" {
  value       = oci_network_load_balancer_listener.minecraft_listener.id
  description = "OCID of the minecraft listener"
}
