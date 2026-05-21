# variables.tf

# project

variable "environment_slug" {
  type        = string
  description = "Environment slug to create folders in"
  default     = "prod"
}

variable "folders" {
  type        = list(string)
  description = "List of secret folders to create in the environment"
  default     = []
}

variable "identity_name" {
  type        = string
  description = "Name of the machine identity"
}

variable "org_id" {
  type        = string
  description = "Infisical organization ID"
}

variable "project_name" {
  type        = string
  description = "Display name for the Infisical project"
}

variable "project_slug" {
  type        = string
  description = "Slug for the Infisical project"
}

# token

variable "access_token_max_ttl" {
  type        = number
  description = "Access token max TTL in seconds"
  default     = 7200

  validation {
    condition     = var.access_token_max_ttl >= var.access_token_ttl
    error_message = "access_token_max_ttl must be greater than or equal to access_token_ttl"
  }
}

variable "access_token_num_uses_limit" {
  type        = number
  description = "Max number of uses per access token, 0 means unlimited"
  default     = 0

  validation {
    condition     = var.access_token_num_uses_limit >= 0
    error_message = "access_token_num_uses_limit must be 0 or greater"
  }
}

variable "access_token_ttl" {
  type        = number
  description = "Access token TTL in seconds"
  default     = 7200

  validation {
    condition     = var.access_token_ttl > 0
    error_message = "access_token_ttl must be greater than 0"
  }
}
