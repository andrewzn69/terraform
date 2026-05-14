# variables.tf

variable "org_id" {
  description = "Infisical organization ID"
  type        = string
}

variable "identity_name" {
  description = "Name of the machine identity"
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

variable "environment_slug" {
  description = "Environment slug to create folders in"
  type        = string
  default     = "prod"
}

variable "folders" {
  description = "List of secret folders to create in the environment"
  type        = list(string)
  default     = []
}

variable "access_token_ttl" {
  description = "Access token TTL in seconds"
  type        = number
  default     = 7200
}

variable "access_token_max_ttl" {
  description = "Access token max TTL in seconds"
  type        = number
  default     = 7200
}

variable "access_token_num_uses_limit" {
  description = "Max number of uses per access token, 0 means unlimited"
  type        = number
  default     = 0
}
