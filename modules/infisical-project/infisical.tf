# infisical.tf

resource "infisical_project" "this" {
  name = var.project_name
  slug = var.project_slug
  type = "secret-manager"

  should_create_default_envs = true
}

resource "infisical_identity" "this" {
  name   = var.identity_name
  role   = "no-access"
  org_id = var.org_id
}

resource "infisical_identity_universal_auth" "this" {
  identity_id = infisical_identity.this.id

  access_token_ttl            = var.access_token_ttl
  access_token_max_ttl        = var.access_token_max_ttl
  access_token_num_uses_limit = var.access_token_num_uses_limit
}

resource "infisical_identity_universal_auth_client_secret" "this" {
  identity_id = infisical_identity.this.id

  depends_on = [infisical_identity_universal_auth.this]
}

resource "infisical_project_identity" "this" {
  project_id  = infisical_project.this.id
  identity_id = infisical_identity.this.id

  roles = [
    {
      role_slug = "viewer"
    }
  ]
}

locals {
  all_paths = toset(flatten([
    for p in var.folders : [
      for i in range(length(split("/", p))) :
      join("/", slice(split("/", p), 0, i + 1))
    ]
  ]))

  depth1 = toset([for p in local.all_paths : p if length(split("/", p)) == 1])
  depth2 = toset([for p in local.all_paths : p if length(split("/", p)) == 2])
}

resource "infisical_secret_folder" "depth1" {
  for_each         = local.depth1
  project_id       = infisical_project.this.id
  environment_slug = var.environment_slug
  folder_path      = "/"
  name             = each.value
}

resource "infisical_secret_folder" "depth2" {
  for_each         = local.depth2
  project_id       = infisical_project.this.id
  environment_slug = var.environment_slug
  folder_path      = "/${split("/", each.value)[0]}"
  name             = split("/", each.value)[1]
  depends_on       = [infisical_secret_folder.depth1]
}
