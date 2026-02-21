# create env for this cluster
resource "infisical_project_environment" "this" {
  project_id = var.project_id
  name       = "${var.environment}-${var.cluster_name}"
  slug       = "${var.environment}-${var.cluster_name}"
}

# folder structure
resource "infisical_secret_folder" "infrastructure" {
  project_id       = var.project_id
  environment_slug = infisical_project_environment.this.slug
  name             = "infrastructure"
  path             = "/"
}

resource "infisical_secret_folder" "apps" {
  project_id       = var.project_id
  environment_slug = infisical_project_environment.this.slug
  name             = "apps"
  path             = "/"
}

resource "infisical_secret_folder" "media" {
  project_id       = var.project_id
  environment_slug = infisical_project_environment.this.slug
  name             = "media"
  path             = "/"
}

resource "infisical_secret_folder" "observability" {
  project_id       = var.project_id
  environment_slug = infisical_project_environment.this.slug
  name             = "observability"
  path             = "/"
}

# machine identity for kubernetes operator
resource "infisical_identity" "k8s_operator" {
  name   = "${var.cluster_name}-k8s-operator"
  org_id = var.organization_id
  role   = "no-access"
}

# enable universal auth on identity
resource "infisical_identity_universal_auth" "k8s_operator" {
  identity_id = infisical_identity.k8s_operator.id

  client_secret_trusts        = []
  access_token_ttl            = 7200
  access_token_max_ttl        = 7200
  access_token_num_uses_limit = 0
  access_token_trusted_ips    = []
}

# generate client secret
resource "infisical_identity_universal_auth_client_secret" "k8s_operator" {
  identity_id = infisical_identity.k8s_operator.id
  description = "Kubernetes operator credentials for ${var.cluster_name}"
}
