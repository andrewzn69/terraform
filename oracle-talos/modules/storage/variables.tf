variable "compartment_id" {
  description = "The OCID of the compartment where the bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "Name of the object storage bucket"
  type        = string
}

variable "namespace" {
  description = "The Object Storage namespace"
  type        = string
}

variable "access_type" {
  description = "The type of public access enabled on this bucket"
  type        = string
  default     = "NoPublicAccess"
  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.access_type)
    error_message = "Valid values are NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "bucket_versioning" {
  description = "Set to Enabled to enable object versioning"
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.bucket_versioning)
    error_message = "Valid values are Enabled or Disabled."
  }
}

variable "image_object_name" {
  description = "Name of the object in the bucket"
  type        = string
}

variable "image_source_path" {
  description = "Path to the local file to upload"
  type        = string
}

variable "content_type" {
  description = "Content type of the object"
  type        = string
  default     = "application/octet-stream"
}

variable "image_display_name" {
  description = "Display name for the custom image"
  type        = string
  default     = "talos-oracle-arm64"
}

variable "image_operating_system" {
  description = "Operating system of the image"
  type        = string
  default     = "Talos"
}

variable "image_operating_system_version" {
  description = "Operating system version"
  type        = string
  default     = "v1.10.6"
}

variable "source_image_type" {
  description = "Source image type"
  type        = string
  default     = "QCOW2"
}
