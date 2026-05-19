# variables.tf

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}

variable "cluster_type" {
  description = "Type of Kubernetes cluster. Selects the default Cilium values preset."
  type        = string

  validation {
    condition     = contains(["talos", "oke"], var.cluster_type)
    error_message = "Supported cluster types: talos, oke"
  }
}

variable "cluster_endpoint" {
  description = "Kubernetes API endpoint in the format https://host:port. Required when cluster_type is oke."
  type        = string
  default     = null

  validation {
    condition     = var.cluster_endpoint == null || can(regex("^https://", var.cluster_endpoint))
    error_message = "cluster_endpoint must start with https://"
  }

  validation {
    condition     = var.cluster_type != "oke" || var.cluster_endpoint != null
    error_message = "cluster_endpoint is required when cluster_type is oke"
  }
}

variable "values_local" {
  description = "Cilium Helm values as a YAML string, replaces the default values.yaml"
  type        = string
  default     = null
}

variable "values_url" {
  description = "URL to fetch Cilium Helm values from, replaces the default values.yaml"
  type        = string
  default     = null
}
