variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "valhalla"
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.10.6"
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint URL"
  type        = string
}

# load balancer vars
variable "load_balancer_ip" {
  description = "IP address of the load balancer"
  type        = string
}

variable "network_load_balancer_id" {
  description = "ID of the network load balancer"
  type        = string
}

variable "talos_backend_set_name" {
  description = "Name of the talos backend set"
  type        = string
}

variable "controlplane_backend_set_name" {
  description = "Name of the controlplane backend set"
  type        = string
}

# image vars
variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

# object storage vars (for custom image)
variable "object_bucket" {
  description = "Name of the storage bucket containing the Talos image"
  type        = string
}

variable "object_namespace" {
  description = "Namespace of the storage bucket"
  type        = string
}

variable "object_object" {
  description = "Name of the Talos image object in the bucket"
  type        = string
}

variable "custom_image_id" {
  description = "OCID of the custom Talos image"
  type        = string
}

variable "talos_backend_port" {
  description = "Port for Talos API backend"
  type        = number
  default     = 50000
}

variable "controlplane_backend_port" {
  description = "Port for Kubernetes API backend"
  type        = number
  default     = 6443
}

# instance vars
variable "subnet_id" {
  description = "ID of the subnet for instances"
  type        = string
}

variable "instance_shape" {
  description = "Shape for instances"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_create_vnic_details_assign_public_ip" {
  description = "Whether to assign public IP"
  type        = bool
  default     = true
}

variable "instance_launch_options_network_type" {
  description = "Network type for instances"
  type        = string
  default     = "PARAVIRTUALIZED"
}

# controlplane vars
# TODO: not hardcode the number
variable "controlplane_display_name" {
  description = "Display name for controlplane instance"
  type        = string
  default     = "controlplane-1"
}

variable "controlplane_private_ip" {
  description = "Private IP for controlplane instance"
  type        = string
}

variable "controlplane_memory_in_gbs" {
  description = "Memory in GBs for controlplane"
  type        = number
  default     = 4
}

variable "controlplane_ocpus" {
  description = "OCPUs for controlplane"
  type        = number
  default     = 1
}

# worker vars
# TODO: not hardcode the number
variable "worker_display_name" {
  description = "Display name for worker instance"
  type        = string
  default     = "worker-1"
}

variable "worker_private_ip" {
  description = "Private IP for worker instance"
  type        = string
}

variable "worker_memory_in_gbs" {
  description = "Memory in GBs for worker"
  type        = number
  default     = 20
}

variable "worker_ocpus" {
  description = "OCPUs for worker"
  type        = number
  default     = 3
}
