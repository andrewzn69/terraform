# variables.tf

# workspace

variable "name" {
  description = "Name of the workspace"
  type        = string
}

variable "organization" {
  description = "Name of the HCP Terraform organization"
  type        = string
}

variable "working_directory" {
  description = "Working directory within the VCS repo. When null, defaults to the repo root."
  type        = string
  default     = null
}

variable "trigger_prefixes" {
  description = "Path prefixes that trigger runs when changed"
  type        = list(string)
  default     = []
}

variable "auto_apply" {
  description = "Whether to automatically apply successful plans"
  type        = bool
  default     = false
}

# vcs

variable "vcs_repo_identifier" {
  description = "VCS repo identifier in the format org/repo. When null, the workspace has no VCS."
  type        = string
  default     = null
}

variable "vcs_branch" {
  description = "Branch to track in the VCS repo. When null, it uses the repo's default branch."
  type        = string
  default     = null
}

variable "github_app_installation_id" {
  description = "GitHub App installation ID for VCS integration. Required when vcs_repo_identifier is set"
  type        = string
  default     = null

  validation {
    condition     = var.vcs_repo_identifier == null || var.github_app_installation_id != null
    error_message = "github_app_installation_id is required when vcs_repo_identifier is set."
  }
}

# execution

variable "execution_mode" {
  description = "Execution mode for the workspace. One of: remote, local, agent."
  type        = string
  default     = "remote"

  validation {
    condition     = contains(["remote", "local", "agent"], var.execution_mode)
    error_message = "execution_mode must be one of: remote, local, agent."
  }
}

variable "agent_pool_id" {
  description = "Agent pool ID for workspace execution. Required when execution_mode is agent."
  type        = string
  default     = null

  validation {
    condition     = var.execution_mode != "agent" || var.agent_pool_id != null
    error_message = "agent_pool_id is required when execution_mode is agent."
  }
}

# variables

variable "variables" {
  description = "Terraform variables to create in the workspace. Sensitive variables are created with ignore_changes on value."
  type = map(object({
    value     = string
    sensitive = optional(bool, false)
    category  = optional(string, "terraform")
  }))
  default = {}
}

# variable sets

variable "variable_set_ids" {
  description = "Variable set IDs to attach to this workspace"
  type        = list(string)
  default     = []
}
