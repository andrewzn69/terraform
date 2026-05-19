# workspace.tf

resource "tfe_workspace" "this" {
  name              = var.name
  organization      = var.organization
  working_directory = var.working_directory
  trigger_prefixes  = var.trigger_prefixes
  auto_apply        = var.auto_apply

  dynamic "vcs_repo" {
    for_each = var.vcs_repo_identifier != null ? [1] : []
    content {
      identifier                 = var.vcs_repo_identifier
      branch                     = var.vcs_branch
      github_app_installation_id = var.github_app_installation_id
    }
  }
}

resource "tfe_workspace_settings" "this" {
  workspace_id   = tfe_workspace.this.id
  execution_mode = var.execution_mode
  agent_pool_id  = var.execution_mode == "agent" ? var.agent_pool_id : null
}

resource "tfe_variable" "managed" {
  for_each = { for k, v in var.variables : k => v if !v.sensitive }

  workspace_id = tfe_workspace.this.id
  key          = each.key
  value        = each.value.value
  sensitive    = false
  category     = each.value.category
}

resource "tfe_variable" "sensitive" {
  for_each = { for k, v in var.variables : k => v if v.sensitive }

  workspace_id = tfe_workspace.this.id
  key          = each.key
  value        = each.value.value
  sensitive    = true
  category     = each.value.category

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_workspace_variable_set" "this" {
  for_each = toset(var.variable_set_ids)

  workspace_id    = tfe_workspace.this.id
  variable_set_id = each.value
}
