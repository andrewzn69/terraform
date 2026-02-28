variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster, used for resource naming"
  type        = string
}

variable "vcn_cidr_blocks" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "talos_listener_port" {
  description = "Port for Talos API listener"
  type        = number
}

variable "controlplane_listener_port" {
  description = "Port for Kubernetes API listener"
  type        = number
}
