# variables.tf

variable "argocd_version" {
  type        = string
  description = "ArgoCD Helm chart version"
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
}
