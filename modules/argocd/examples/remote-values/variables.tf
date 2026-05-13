variable "argocd_version" {
  description = "ArgoCD Helm chart version"
  type        = string
}

variable "values_url" {
  description = "URL to fetch ArgoCD Helm values from"
  type        = string
}

variable "kubernetes_host" {
  description = "Kubernetes API server URL"
  type        = string
}

variable "kubernetes_client_certificate" {
  description = "Kubernetes client certificate (PEM)"
  type        = string
  sensitive   = true
}

variable "kubernetes_client_key" {
  description = "Kubernetes client key (PEM)"
  type        = string
  sensitive   = true
}

variable "kubernetes_cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate (PEM)"
  type        = string
  sensitive   = true
}
