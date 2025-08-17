variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

# storage vars
variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
}

variable "namespace" {
  description = "Object Storage namespace"
  type        = string
}

variable "image_object_name" {
  description = "Name of the image object"
  type        = string
}

variable "image_source_path" {
  description = "Path to the image file"
  type        = string
}

# network vars
variable "vcn_cidr_blocks" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

# compute vars
variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "valhalla"
}

variable "controlplane_display_name" {
  description = "Display name for controlplane instance"
  type        = string
  default     = "controlplane-1"
}

variable "controlplane_private_ip" {
  description = "Private IP for controlplane instance"
  type        = string
}

variable "worker_display_name" {
  description = "Display name for worker instance"
  type        = string
  default     = "worker-1"
}

variable "worker_private_ip" {
  description = "Private IP for worker instance"
  type        = string
}
