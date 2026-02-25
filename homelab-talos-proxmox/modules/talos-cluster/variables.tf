# variables.tf - input vars for the talos-cluster module

# --- proxmox ---

variable "proxmox_host" {
  description = "Proxmox node name hosting the VMs"
  type        = string
}

variable "proxmox_storage" {
  description = "Proxmox storage pool for VM OS disks"
  type        = string
}

variable "cloudinit_storage" {
  description = "Proxmox directory storage for cloud-init drives"
  type        = string
}

variable "proxmox_bridge" {
  description = "Proxmox network bridge for VM NICs"
  type        = string
}

# --- networking ---

variable "gateway_ip" {
  description = "Gateway IP address for VM network config"
  type        = string
}

variable "node_subnet" {
  description = "Subnet CIDR for Talos nodes"
  type        = string
}

variable "ip_range_start" {
  description = "Host offset within the subnet for the first VM IP"
  type        = number
}

# --- vms ---

variable "number_of_vms" {
  description = "Total number of Talos VMs (control plane + workers)"
  type        = number
}

variable "control_plane_vm_count" {
  description = "Number of control plane VMs"
  type        = number
  validation {
    condition     = var.control_plane_vm_count % 2 == 1
    error_message = "control_plane_vm_count must be odd (1 or 3) for etcd quorum."
  }
}

variable "control_plane_vm_id_start" {
  description = "Starting VM ID for control plane VMs"
  type        = number
  default     = 101
}

variable "worker_vm_id_start" {
  description = "Starting VM ID for worker VMs"
  type        = number
  default     = 201
}

variable "control_plane_cpu" {
  description = "CPU cores for control plane VMs"
  type        = number
}

variable "control_plane_memory" {
  description = "Memory for control plane VMs in MB"
  type        = number
}

variable "control_plane_disk_size" {
  description = "OS disk size for control plane VMs"
  type        = number
}

variable "worker_cpu" {
  description = "CPU cores for worker VMs"
  type        = number
}

variable "worker_memory" {
  description = "Memory for worker VMs in MB"
  type        = number
}

variable "worker_disk_size" {
  description = "OS disk size for worker VMs"
  type        = number
}

variable "worker_data_storage" {
  description = "Proxmox storage pool for worker data disks (HDD pool)"
  type        = string
}

variable "worker_data_disk_size" {
  description = "Data disk size for worker VMs"
  type        = number
}

# --- talos ---

variable "talos_version" {
  description = "Talos version for machine configuration generation"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
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

variable "cluster_api_host" {
  description = "Optional stable dns hostname for the API endpoint. Falls back to cluster_endpoint if null."
  type        = string
  default     = null
}

variable "tailscale_auth_key" {
  description = "Tailscale authentication key for node connectivity"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}

# --- argocd ---

variable "github_app_id" {
  description = "GitHub App ID for ArgoCD repository authentication"
  type        = string
  sensitive   = true
}

variable "github_app_installation_id" {
  description = "GitHub App Installation ID"
  type        = string
  sensitive   = true
}

variable "github_app_private_key" {
  description = "GitHub App private key (PEM format)"
  type        = string
  sensitive   = true
}
