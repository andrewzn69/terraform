# variables.tf

variable "control_plane_ips" {
  type        = list(string)
  description = "IP addresses of control plane nodes"
}

variable "worker_ips" {
  type        = list(string)
  description = "IP addresses of worker nodes"
}

variable "talos_version" {
  type        = string
  description = "Talos version"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster"
}

variable "cluster_endpoint" {
  type        = string
  description = "Full URL of the Kubernetes API endpoint"
}

variable "node_subnet" {
  type        = string
  description = "Subnet CIDR used for kubelet nodeIP validation"
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
