variable "project_id" {
  description = "Infisical project ID"
  type        = string
}

variable "organization_id" {
  description = "Infisical organization ID"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name (homelab, oracle, aws)"
  type        = string
}

variable "environment" {
  description = "Environment name (production, staging, dev)"
  type        = string
  default     = "production"
}
