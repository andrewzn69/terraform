# --- oci ---

variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

# --- network ---

variable "vcn_id" {
  description = "OCID of the VCN"
  type        = string
}

variable "endpoint_subnet_id" {
  description = "OCID of the cluster endpoint and LB subnet"
  type        = string
}

variable "nodes_subnet_id" {
  description = "OCID of the worker nodes subnet"
  type        = string
}

# --- cluster ---

variable "cluster_name" {
  description = "Name of the OKE cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

# --- node pool ---

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "node_ocpus" {
  description = "OCPUs per worker node"
  type        = number
}

variable "node_memory_gb" {
  description = "Memory in GB per worker node"
  type        = number
}

# --- storage ---

variable "node_boot_volume_size_gb" {
  description = "Boot volume size in GB per worker node"
  type        = number
}

variable "node_block_volume_size_gb" {
  description = "Block volume size in GB per worker node"
  type        = number
}

# --- networking ---

variable "pods_cidr" {
  description = "CIDR for pod networking"
  type        = string
  default     = "10.244.0.0/16"
}

variable "services_cidr" {
  description = "CIDR for service networking"
  type        = string
  default     = "10.96.0.0/16"
}

# --- tailscale ---

variable "tailscale_auth_key" {
  description = "Tailscale auth key for node join"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for node access"
  type        = string
  default     = null
}
