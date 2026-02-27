# variables.tf - env vars

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

variable "namespace" {
  description = "OCI Object Storage namespace"
  type        = string
}

# --- network ---

variable "vcn_cidr_blocks" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

# --- cluster ---

variable "cluster_name" {
  description = "Name of the Talos Cluster"
  type        = string
}

variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type        = string
  sensitive   = true
}

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}

# --- instance config ---

variable "instance_shape" {
  description = "Shape for instances"
  type        = string
}

variable "instance_launch_options_network_type" {
  description = "Network type for instances"
  type        = string
}

variable "boot_volume_size_gb" {
  description = "Boot volume size in GB for all nodes"
  type        = number
}

# --- controlplane pool ---

variable "controlplane_count" {
  description = "Number of controlplane nodes"
  type        = number
}

variable "controlplane_memory_gb" {
  description = "Memory in GB per controlplane node"
  type        = number
}

variable "controlplane_ocpus" {
  description = "OCPUs per control plane"
  type        = number
}

variable "controlplane_base_ip_offset" {
  description = "Starting IP offset for controlplane nodes"
  type        = number
}

# --- worker pool ---

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "worker_memory_gb" {
  description = "Memory in GB per worker node"
  type        = number
}

variable "worker_ocpus" {
  description = "OCPUs per worker node"
  type        = number
}

variable "worker_base_ip_offset" {
  description = "Starting IP offset for worker nodes"
  type        = number
}

variable "worker_data_volume_size_gb" {
  description = "Data volume size in GB per worker"
  type        = number
}

# --- ports ---

variable "talos_backend_port" {
  description = "Port for Talos API backend"
  type        = number
}

variable "controlplane_backend_port" {
  description = "Port for Kubernetes API backend"
  type        = number
}

# --- free tier limits ---

variable "free_tier_memory_limit" {
  description = "Oracle free tier memory limit in GB"
  type        = number
}

variable "free_tier_ocpu_limit" {
  description = "Oracle free tier OCPU limit"
  type        = number
}

variable "free_tier_storage_limit_gb" {
  description = "Oracle free tier total storage limit in GB"
  type        = number
}
