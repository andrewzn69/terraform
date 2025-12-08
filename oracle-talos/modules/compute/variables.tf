# cluster config

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.11.5"
}

variable "talos_factory_schematic_id" {
  description = "Talos factory schematic ID for installer image with extension"
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

# network config

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

variable "subnet_id" {
  description = "ID of the subnet for instances"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block of the subnet for IP assignment"
  type        = string
}

# image config

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "custom_image_id" {
  description = "OCID of the custom Talos image"
  type        = string
}

# instance config

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

# controlplane pool config

variable "controlplane_count" {
  description = "Number of controlplane nodes"
  type        = number
  default     = 1
}

variable "controlplane_memory_gb" {
  description = "Memory in GB per controlplane node"
  type        = number
  default     = 4
}

variable "controlplane_ocpus" {
  description = "OCPUs per controlplane node"
  type        = number
  default     = 1
}

variable "controlplane_base_ip_offset" {
  description = "Starting IP offset for controlplane nodes (e.g., 10 for 10.0.1.10)"
  type        = number
  default     = 10
}

# worker pool config

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 1
}

variable "worker_memory_gb" {
  description = "Memory in GB per worker node"
  type        = number
  default     = 20
}

variable "worker_ocpus" {
  description = "OCPUs per worker node"
  type        = number
  default     = 3
}

variable "worker_base_ip_offset" {
  description = "Starting IP offset for worker nodes (e.g., 20 for 10.0.1.20)"
  type        = number
  default     = 20
}

variable "worker_boot_volume_size_gb" {
  description = "Boot volume size in GB for worker nodes"
  type        = number
  default     = 50
}

# variable "instance_launch_volume_attachments_type" {
#   description = "Volume attachment type"
#   type        = string
#   default     = "iscsi"
# }
#
# variable "instance_launch_volume_attachments_launch_create_volume_details_size_in_gbs" {
#   description = "Size of the volume in Gbs"
#   type        = number
#   default     = 50
# }
#
# variable "instance_launch_volume_attachments_launch_create_volume_details_volume_creation_type" {
#   description = "Volume creation type"
#   type        = string
#   default     = "ATTRIBUTES"
# }

# free tier validation
locals {
  total_memory = (var.controlplane_count * var.controlplane_memory_gb) + (var.worker_count * var.worker_memory_gb)
  total_ocpus  = (var.controlplane_count * var.controlplane_ocpus) + (var.worker_count * var.worker_ocpus)
}

variable "free_tier_memory_limit" {
  description = "Oracle free tier memory limit in GB"
  type        = number
  default     = 24
}

variable "free_tier_ocpu_limit" {
  description = "Oracle free tier OCPU limit"
  type        = number
  default     = 4
}

resource "null_resource" "validate_free_tier" {
  lifecycle {
    precondition {
      condition     = local.total_memory <= var.free_tier_memory_limit
      error_message = "Total memory (${local.total_memory}GB) exceeds free tier limit (${var.free_tier_memory_limit}GB). Controlplane: ${var.controlplane_count}x${var.controlplane_memory_gb}GB, Worker: ${var.worker_count}x${var.worker_memory_gb}GB"
    }

    precondition {
      condition     = local.total_ocpus <= var.free_tier_ocpu_limit
      error_message = "Total OCPUs (${local.total_ocpus}) exceeds free tier limit (${var.free_tier_ocpu_limit}). Controlplane: ${var.controlplane_count}x${var.controlplane_ocpus}, Worker: ${var.worker_count}x${var.worker_ocpus}"
    }
  }
}

# # object storage vars (for custom image)
# variable "object_bucket" {
#   description = "Name of the storage bucket containing the Talos image"
#   type        = string
# }
#
# variable "object_namespace" {
#   description = "Namespace of the storage bucket"
#   type        = string
# }
#
# variable "object_object" {
#   description = "Name of the Talos image object in the bucket"
#   type        = string
# }

# variable "minecraft_backend_set_name" {
#   description = "Name of the minecraft backend set"
#   type        = string
# }
#
# variable "minecraft_backend_port" {
#   description = "Port for Minecraft backend (NodePort)"
#   type        = number
#   default     = 31000
# }
