resource "tfe_workspace" "oracle_oke_prod" {
  name              = "oracle-oke-prod"
  organization      = "zemn"
  working_directory = "oracle-oke/envs/prod"
  trigger_prefixes  = ["oracle-oke/"]
  auto_apply        = true

  vcs_repo {
    identifier                 = "andrewzn69/terraform"
    branch                     = "master"
    github_app_installation_id = var.github_app_installation_id
  }
}

resource "tfe_workspace_settings" "oracle_oke_prod" {
  workspace_id   = tfe_workspace.oracle_oke_prod.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool.homelab.id
}

# --- oci auth ---

resource "tfe_variable" "oke_tenancy_ocid" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "tenancy_ocid"
  value        = ""
  category     = "terraform"
  sensitive    = true
  lifecycle { ignore_changes = [value] }
}

resource "tfe_variable" "oke_user_ocid" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "user_ocid"
  value        = ""
  category     = "terraform"
  sensitive    = true
  lifecycle { ignore_changes = [value] }
}

resource "tfe_variable" "oke_fingerprint" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "fingerprint"
  value        = ""
  category     = "terraform"
  sensitive    = true
  lifecycle { ignore_changes = [value] }
}

resource "tfe_variable" "oke_private_key" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "oci_private_key"
  value        = ""
  category     = "terraform"
  sensitive    = true
  lifecycle { ignore_changes = [value] }
}

resource "tfe_variable" "oke_region" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "region"
  value        = "eu-frankfurt-1"
  category     = "terraform"
}

resource "tfe_variable" "oke_compartment_id" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "compartment_id"
  value        = ""
  category     = "terraform"
  sensitive    = true
  lifecycle { ignore_changes = [value] }
}

# --- cluster ---

resource "tfe_variable" "oke_kubernetes_version" {
  workspace_id = tfe_workspace.oracle_oke_prod.id
  key          = "kubernetes_version"
  value        = "v1.34.2"
  category     = "terraform"
}


