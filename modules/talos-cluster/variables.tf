# variables.tf

# cluster

variable "cluster_endpoint" {
  type        = string
  description = "Full URL of the Kubernetes API endpoint"

  validation {
    condition     = can(regex("^https://", var.cluster_endpoint))
    error_message = "cluster_endpoint must start with https://"
  }
}

variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster"
}

# network

variable "control_plane_ips" {
  type        = list(string)
  description = "IP addresses of control plane nodes"
}

variable "node_subnet" {
  type        = string
  description = "Subnet CIDR used for kubelet nodeIP validation"

  validation {
    condition     = can(cidrhost(var.node_subnet, 0))
    error_message = "node_subnet must be a valid CIDR notation"
  }
}

variable "worker_ips" {
  type        = list(string)
  description = "IP addresses of worker nodes"
}

# talos

variable "extra_control_plane_patches" {
  type        = list(string)
  description = "Additional Talos config patches for control plane nodes (YAML strings)"
  default     = []
}

variable "extra_worker_patches" {
  type        = list(string)
  description = "Additional Talos config patches for worker nodes (YAML strings)"
  default     = []
}

variable "install_disk" {
  type        = string
  description = "Disk path for Talos installation"
  default     = "/dev/sda"
}

variable "installer_image" {
  type        = string
  description = "Talos installer OCI image reference"
}

variable "talos_version" {
  type        = string
  description = "Talos version"

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+", var.talos_version))
    error_message = "talos_version must start with vX.Y.Z"
  }
}
