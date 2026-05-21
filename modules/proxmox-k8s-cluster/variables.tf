# variables.tf

variable "control_plane_groups" {
  type = list(object({
    name              = string # unique group name, used as vm name prefix
    node_name         = string # proxmox node name where vms will be created
    count             = number # number of control plane vms in this group
    vm_id_start       = number # starting proxmox vm id, increments per vm
    ip_range_start    = number # host offset in node_subnet for the first vm, increments per vm
    cpu               = number # vcpu count for vm
    memory            = number # ram per vm in MB
    disk_size         = number # os boot disk size in GB
    storage           = string # proxmox storage pool for the boot disk
    cloudinit_storage = string # proxmox storage pool for the cloud-init drive
    bridge            = string # proxmox network bridge for the vm nic
  }))
  description = "Control plane node groups"
}

variable "worker_groups" {
  type = list(object({
    name              = string           # unique group name, used as vm name prefix
    node_name         = string           # proxmox node name where vms will be created
    count             = number           # number of worker vms in this group
    vm_id_start       = number           # starting proxmox vm id, increments per vm
    ip_range_start    = number           # host offset in node_subnet for the first vm, increments per vm
    cpu               = number           # vcpu count per vm
    memory            = number           # ram per vm in MB
    disk_size         = number           # os boot disk size in GB
    storage           = string           # proxmox storage pool for the boot disk
    cloudinit_storage = string           # proxmox storage pool for the cloud-init drive
    bridge            = string           # proxmox network bridge for the vm nic
    data_disk_size    = optional(number) # secondary data disk size in GB, used for persistent storage (e.g. CSI)
    data_storage      = optional(string) # proxmox storage pool for the data disk
  }))
  description = "Worker node groups"
}

variable "gateway_ip" {
  type        = string
  description = "Gateway IP for VM network config"
}

variable "node_subnet" {
  type        = string
  description = "Subnet CIDR for node network config"
}

variable "iso_url" {
  type        = string
  description = "URL of the OS ISO to download to Proxmox nodes"
}

variable "iso_datastore_id" {
  type        = string
  description = "Proxmox datastore to download the ISO into"
  default     = "local"
}
