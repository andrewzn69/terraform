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
