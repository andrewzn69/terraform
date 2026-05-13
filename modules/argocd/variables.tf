# variables.tf

variable "argocd_version" {
  description = "ArgoCD Helm chart version"
  type        = string
}

variable "values_local" {
  description = "ArgoCD Helm values as a YAML string, replaces the default values.yaml"
  type        = string
  default     = null
}

variable "values_url" {
  description = "URL to fetch ArgoCD Helm values from, replaces the default values.yaml"
  type        = string
  default     = null
}
