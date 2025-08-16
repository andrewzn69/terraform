variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
  default     = "valhalla"
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint URL"
  type        = string
}

variable "load_balancer_ip" {
  description = "IP address of the load balancer"
  type        = string
}

variable "talos_version" {
  description = "Talos version"
  type        = string
  default     = "v1.10.6"
}
