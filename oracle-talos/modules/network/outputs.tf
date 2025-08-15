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
