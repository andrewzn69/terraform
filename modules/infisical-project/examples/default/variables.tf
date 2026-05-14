variable "infisical_client_id" {
  description = "Infisical machine identity client ID for Terraform authentication"
  type        = string
  sensitive   = true
}

variable "infisical_client_secret" {
  description = "Infisical machine identity client secret for Terraform authentication"
  type        = string
  sensitive   = true
}

variable "org_id" {
  description = "Infisical organization ID"
  type        = string
}

variable "identity_name" {
  description = "Name for the machine identity"
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

variable "folders" {
  description = "List of folder paths to create"
  type        = list(string)
  default     = []
}
