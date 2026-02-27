# variables.tf - storage module variables

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "namespace" {
  description = "Object Storage namespace"
  type        = string
}

variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
  default     = "talos-images-prod"
}

variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "disk_image_url" {
  description = "QCOW2 disk image URL to download from Talos factory"
  type        = string
}
