# variables.tf

variable "argocd_version" {
  type        = string
  description = "ArgoCD Helm chart version"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.argocd_version))
    error_message = "argocd_version must be in format X.Y.Z"
  }
}

variable "values_local" {
  type        = string
  description = "ArgoCD Helm values as a YAML string, replaces the default values.yaml"
  default     = null
}

variable "values_url" {
  type        = string
  description = "URL to fetch ArgoCD Helm values from, replaces the default values.yaml"
  default     = null

  validation {
    condition     = var.values_url == null || can(regex("^https?://", var.values_url))
    error_message = "values_url must be a valid http or https URL"
  }
}
