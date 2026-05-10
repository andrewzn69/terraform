variable "proxmox_endpoint" {
  description = "URL of the Proxmox API endpoint"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the format user@realm!tokenid=secret"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for the Proxmox API"
  type        = bool
  default     = false
}

variable "iso_url" {
  description = "URL of the OS ISO to download to Proxmox nodes"
  type        = string
}

variable "iso_datastore_id" {
  description = "Proxmox datastore to download the ISO into"
  type        = string
  default     = "local"
}

variable "gateway_ip" {
  description = "Gateway IP for VM network config"
  type        = string
}

variable "node_subnet" {
  description = "Subnet CIDR for node network config"
  type        = string
}

variable "control_plane_groups" {
  description = "Control plane node groups"
  type = list(object({
    name              = string
    node_name         = string
    count             = number
    vm_id_start       = number
    ip_range_start    = number
    cpu               = number
    memory            = number
    disk_size         = number
    storage           = string
    cloudinit_storage = string
    bridge            = string
  }))
}

variable "worker_groups" {
  description = "Worker node groups"
  type = list(object({
    name              = string
    node_name         = string
    count             = number
    vm_id_start       = number
    ip_range_start    = number
    cpu               = number
    memory            = number
    disk_size         = number
    storage           = string
    cloudinit_storage = string
    bridge            = string
    data_disk_size    = number
    data_storage      = string
  }))
}
