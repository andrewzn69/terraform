# variables.tf

variable "control_plane_ips" {
  description = "IP addresses of control plane nodes"
  type        = list(string)
}

variable "worker_ips" {
  description = "IP addresses of worker nodes"
  type        = list(string)
}

variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Full URL of the Kubernetes API endpoint"
  type        = string
}

variable "node_subnet" {
  description = "Subnet CIDR used for kubelet nodeIP validation"
  type        = string
}

variable "install_disk" {
  description = "Disk path for Talos installation"
  type        = string
  default     = "/dev/sda"
}

variable "schematic_extensions" {
  description = "List of Talos image factory official extensions to include in the schematic"
  type        = list(string)
  default     = []
}

variable "extra_control_plane_patches" {
  description = "Additional Talos config patches for control plane nodes (YAML strings)"
  type        = list(string)
  default     = []
}

variable "extra_worker_patches" {
  description = "Additional Talos config patches for worker nodes (YAML strings)"
  type        = list(string)
  default     = []
}
