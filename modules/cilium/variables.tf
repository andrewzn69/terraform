# variables.tf

variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
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
