variable "project_id" {
  description = "The Infisical project ID"
  type        = string
}

variable "org_id" {
  description = "The Infisical organization ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "environment_name" {
  description = "Environment name in Infisical"
  type        = string
}
