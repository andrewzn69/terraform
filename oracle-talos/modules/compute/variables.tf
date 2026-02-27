# --- cluster config ---

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "installer_image_url" {
  description = "Talos installer image URL for machine config patches"
  type        = string
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key for node authentication"
  type        = string
  sensitive   = true
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint URL"
  type        = string
}

# --- network config ---

variable "load_balancer_ip" {
  description = "IP address of the load balancer"
  type        = string
}

variable "network_load_balancer_id" {
  description = "ID of the network load balancer"
  type        = string
}

variable "talos_backend_set_name" {
  description = "Name of the Talos backend set"
  type        = string
}

variable "controlplane_backend_set_name" {
  description = "Name of the controlplane backend set"
  type        = string
}

variable "talos_backend_port" {
  description = "Port for Talos API backend"
  type        = number
}

variable "controlplane_backend_port" {
  description = "Port for Kubernetes API backend"
  type        = number
}

variable "subnet_cidr" {
  description = "CIDR block of the subnet for IP assignment"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for instances"
  type        = string
}

# --- image config ---

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "custom_image_id" {
  description = "OCID of the custom Talos image"
  type        = string
}

# --- instance config ---

variable "instance_shape" {
  description = "Shape for instances"
  type        = string
}

variable "instance_launch_options_network_type" {
  description = "Network type for instance"
  type        = string
}

variable "boot_volume_size_gb" {
  description = "Boot volume size in GB for all nodes"
  type        = number
}

# --- controlplane pool config ---

variable "controlplane_count" {
  description = "Number of controlplane nodes"
  type        = number
}

variable "controlplane_memory_gb" {
  description = "Memory in GB per controlplane node"
  type        = number
}

variable "controlplane_ocpus" {
  description = "OCPUs per controlplane node"
  type        = number
}

variable "controlplane_base_ip_offset" {
  description = "Starting IP offset for controlplane nodes"
  type        = number
}

# --- worker pool config ---

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
  description = "Block volume size in GB per worker"
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
  description = "Oracle free tier total storage limit in GB (boot volumes + block volumes)"
  type        = number
}

# --- cilium ---

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}
