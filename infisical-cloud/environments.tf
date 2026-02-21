# create shared folder for secrets used by all clusters
resource "infisical_secret_folder" "shared" {
  project_id       = infisical_project.kubernetes.id
  environment_slug = "prod"
  folder_path      = "/"
  name             = "shared"
}

# create vizima cluster env
module "vizima" {
  source = "./modules/cluster-environment"

  project_id       = infisical_project.kubernetes.id
  org_id           = var.org_id
  cluster_name     = "vizima"
  environment_name = "prod"
}
