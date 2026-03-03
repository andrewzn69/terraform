output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.main.id
}

output "endpoint_subnet_id" {
  description = "OCID of the cluster endpoint and LB subnet"
  value       = oci_core_subnet.endpoint.id
}

output "nodes_subnet_id" {
  description = "OCID of the worker nodes subnet"
  value       = oci_core_subnet.nodes.id
}
