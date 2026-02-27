# shared credentials variable set
resource "tfe_variable_set" "shared_credentials" {
  name         = "shared-credentials"
  organization = "zemn"
}

resource "tfe_variable" "tailscale_auth_key" {
  key             = "tailscale_auth_key"
  value           = ""
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.shared_credentials.id

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "cilium_version" {
  key             = "cilium_version"
  value           = "1.19.1"
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_credentials.id
}

resource "tfe_workspace_variable_set" "homelab_talos_prod" {
  workspace_id    = tfe_workspace.homelab_talos_prod.id
  variable_set_id = tfe_variable_set.shared_credentials.id
}

# TODO: setup oracle
# resource "tfe_workspace_variable_set" "oracle_talos_prod" {
#   workspace_id    = tfe_workspace.oracle_talos_prod.id
#   variable_set_id = tfe_variable_set.shared_credentials.id
# }
