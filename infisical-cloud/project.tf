resource "infisical_project" "kubernetes" {
  name        = var.project_name
  slug        = var.project_slug
  description = "Kubernetes clusters secrets management"
  type        = "secret-manager"

  should_create_default_envs = true
}
