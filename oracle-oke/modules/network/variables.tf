variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name (used for resource display names)"
  type        = string
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "endpoint_subnet_cidr_block" {
  description = "CIDR block for the cluster endpoint and LB subnet"
  type        = string
}

variable "nodes_subnet_cidr_block" {
  description = "CIDR block for the worker nodes subnet"
  type        = string
}
