# variables.tf

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}

variable "cluster_endpoint" {
  description = "OKE cluster API endpoint in the format https://host:port"
  type        = string

  validation {
    condition     = can(regex("^https://", var.cluster_endpoint))
    error_message = "cluster_endpoint must start with https://"
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

  validation {
    condition     = var.values_url == null || can(regex("^https?://", var.values_url))
    error_message = "values_url must be a valid http or https url"
  }
}
