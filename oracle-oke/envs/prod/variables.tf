# --- oci auth ---

variable "tenancy_ocid" {
  description = "OCID of the OCI tenancy"
  type        = string
}

variable "user_ocid" {
  description = "OCID of the OCI user"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the OCI API key"
  type        = string
}

variable "oci_private_key" {
  description = "OCI API private key content"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "OCI region"
  type        = string
}

# --- oci compartment ---

variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

# --- network ---

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "endpoint_subnet_cidr_block" {
  description = "CIDR block for the cluster endpoint and LB subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "nodes_subnet_cidr_block" {
  description = "CIDR block for the worker nodes subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# --- cluster ---

variable "cluster_name" {
  description = "Name of the OKE cluster"
  type        = string
  default     = "novigrad"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

# --- node pool ---

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "node_ocpus" {
  description = "OCPUs per worker node"
  type        = number
  default     = 2
}

variable "node_memory_gb" {
  description = "Memory in GB per worker node"
  type        = number
  default     = 12
}

# --- storage ---

variable "node_boot_volume_size_gb" {
  description = "Boot volume size in GB per worker node"
  type        = number
  default     = 50
}

variable "node_block_volume_size_gb" {
  description = "Block volume size in GB per worker node"
  type        = number
  default     = 50
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
  description = "Tailscale auth key"
  type        = string
  sensitive   = true
}

# --- ssh ---

variable "ssh_public_key" {
  description = "SSH public key for node access"
  type        = string
  default     = null
}
