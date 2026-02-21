resource "tfe_workspace" "infisical_cloud" {
  name              = "infisical-cloud"
  organization      = "zemn"
  working_directory = "infisical-cloud"

  vcs_repo {
    identifier                 = "andrewzn69/terraform"
    branch                     = "master"
    github_app_installation_id = var.github_app_installation_id
  }
}

resource "tfe_workspace_settings" "infisical_cloud" {
  workspace_id   = tfe_workspace.infisical_cloud.id
  execution_mode = "remote"
}

resource "tfe_variable" "infisical_client_id" {
  workspace_id = tfe_workspace.infisical_cloud.id
  key          = "infisical_client_id"
  value        = ""
  category     = "terraform"
  sensitive    = false

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "infisical_client_secret" {
  workspace_id = tfe_workspace.infisical_cloud.id
  key          = "infisical_client_secret"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "infisical_org_id" {
  workspace_id = tfe_workspace.infisical_cloud.id
  key          = "org_id"
  value        = ""
  category     = "terraform"
  sensitive    = false

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "infisical_project_name" {
  workspace_id = tfe_workspace.infisical_cloud.id
  key          = "project_name"
  value        = ""
  category     = "terraform"
  sensitive    = false

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "infisical_project_slug" {
  workspace_id = tfe_workspace.infisical_cloud.id
  key          = "project_slug"
  value        = ""
  category     = "terraform"
  sensitive    = false

  lifecycle {
    ignore_changes = [value]
  }
}
