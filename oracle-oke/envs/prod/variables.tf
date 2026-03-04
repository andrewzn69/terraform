# variables.tf - cluster configuration inputs

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

  validation {
    condition     = can(cidrhost(var.vcn_cidr_block, 0))
    error_message = "vcn_cidr_block must be a valid CIDR notation"
  }
}

variable "endpoint_subnet_cidr_block" {
  description = "CIDR block for the cluster endpoint and LB subnet"
  type        = string
  default     = "10.0.0.0/24"

  validation {
    condition     = can(cidrhost(var.endpoint_subnet_cidr_block, 0))
    error_message = "endpoint_subnet_cidr_block must be a valid CIDR notation"
  }
}

variable "nodes_subnet_cidr_block" {
  description = "CIDR block for the worker nodes subnet"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.nodes_subnet_cidr_block, 0))
    error_message = "nodes_subnet_cidr_block must be a valid CIDR notation"
  }
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

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must be in format vX.Y.Z (e.g., v1.34.2)"
  }
}

# --- node pool ---

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2

  validation {
    condition     = var.node_count > 0
    error_message = "node_count must be at least 1"
  }
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

  validation {
    condition     = can(cidrhost(var.pods_cidr, 0))
    error_message = "pods_cidr must be a valid CIDR notation"
  }
}

variable "services_cidr" {
  description = "CIDR for service networking"
  type        = string
  default     = "10.96.0.0/16"

  validation {
    condition     = can(cidrhost(var.services_cidr, 0))
    error_message = "services_cidr must be a valid CIDR notation"
  }
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
