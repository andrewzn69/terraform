# infisical.tf

resource "infisical_project" "this" {
  name = var.project_name
  slug = var.project_slug
  type = "secret-manager"

  should_create_default_envs = true
}

resource "infisical_identity" "this" {
  name   = "k8s-operator-${var.cluster_name}"
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

resource "infisical_secret_folder" "this" {
  for_each = toset(var.folders)

  project_id       = infisical_project.this.id
  environment_slug = var.environment_slug
  folder_path      = "/"
  name             = each.value
}
