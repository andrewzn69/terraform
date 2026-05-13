variable "cilium_version" {
  description = "Cilium Helm chart version"
  type        = string
}

variable "values_url" {
  description = "URl to fetch Cilium Helm values from"
  type        = string
}

variable "kubernetes_host" {
  description = "Kubernetes API server url"
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
