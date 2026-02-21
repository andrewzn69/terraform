resource "infisical_project" "cluster" {
  name        = var.project_name
  slug        = var.project_slug
  description = "Secret management for ${var.cluster_name} Kubernetes cluster"
  type        = "secret-manager"

  should_create_default_envs = true
}

# create machine identity for the cluster
resource "infisical_identity" "cluster" {
  name   = "k8s-operator-${var.cluster_name}"
  role   = "no-access"
  org_id = var.org_id
}

# configure universal auth for the identity
resource "infisical_identity_universal_auth" "cluster" {
  identity_id = infisical_identity.cluster.id

  access_token_ttl            = 7200
  access_token_max_ttl        = 7200
  access_token_num_uses_limit = 0
}

# generate client secret for auth
resource "infisical_identity_universal_auth_client_secret" "cluster" {
  identity_id = infisical_identity.cluster.id

  depends_on = [infisical_identity_universal_auth.cluster]
}

# grant identity access to the project env
resource "infisical_project_identity" "cluster" {
  project_id  = infisical_project.cluster.id
  identity_id = infisical_identity.cluster.id

  roles = [
    {
      role_slug = "viewer"
    }
  ]
}
