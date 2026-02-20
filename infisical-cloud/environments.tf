module "homelab_env" {
  source = "./modules/cluster-environment"

  project_id   = infisical_project.main.id
  cluster_name = "homelab"
  environment  = "production"
}

# TODO: setup oracle
# module "oracle_env" {
#   source = "./modules/cluster-environment"
#
#   project_id   = infisical_project.main.id
#   cluster_name = oracle
#   environment  = "production"
# }
