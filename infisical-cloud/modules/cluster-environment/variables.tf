variable "org_id" {
  description = "The Infisical organization ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "project_name" {
  description = "Display name for the Infisical project"
  type        = string
}

variable "project_slug" {
  description = "Slug for the Infisical project"
  type        = string
}
