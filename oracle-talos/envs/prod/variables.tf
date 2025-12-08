variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

# storage config
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

# network config
variable "vcn_cidr_blocks" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

# cluster config
variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "novigrad"
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.11.5"
}

variable "talos_factory_schematic_id" {
  description = "Talos factory schematic ID for installer image with extension"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true
}

# controlplane pool config
variable "controlplane_count" {
  description = "Number of controlplane nodes"
  type        = number
  default     = 1
}

variable "controlplane_memory_gb" {
  description = "Memory in GB per controlplane node"
  type        = number
  default     = 4
}

variable "controlplane_ocpus" {
  description = "OCPUs per controlplane node"
  type        = number
  default     = 1
}

variable "controlplane_base_ip_offset" {
  description = "Starting IP offset for controlplane nodes"
  type        = number
  default     = 10
}

# worker pool config

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "worker_memory_gb" {
  description = "Memory in GB per controlplane node"
  type        = number
  default     = 20
}

variable "worker_ocpus" {
  description = "OCPUs per worker node"
  type        = number
  default     = 3
}

variable "worker_base_ip_offset" {
  description = "Starting IP offset for worker nodes"
  type        = number
  default     = 20
}

variable "worker_boot_volume_size_gb" {
  description = "Boot volume size in GB for worker nodes"
  type        = number
  default     = 50
}

# variable "minecraft_backend_port" {
#   description = "Port for Minecraft backend (NodePort)"
#   type        = number
#   default     = 31000
# }
