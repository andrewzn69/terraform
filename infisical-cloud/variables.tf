variable "infisical_client_id" {
  description = "Infisical Universal Auth Client ID"
  type        = string
}

variable "infisical_client_secret" {
  description = "Infisical Universal Auth Client Secret"
  type        = string
  sensitive   = true
}

variable "organization_id" {
  description = "Infisical organization ID"
  type        = string
}
