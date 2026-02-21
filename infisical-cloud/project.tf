resource "infisical_project" "main" {
  name   = "kubernetes-clusters"
  slug   = "kubernetes-clusters"
  org_id = var.organization_id
}
