# create vizima cluster project
module "vizima" {
  source = "./modules/cluster-environment"

  org_id       = var.org_id
  cluster_name = "vizima"
  project_name = "Vizima"
  project_slug = "vizima"
}

# top-level folders
resource "infisical_secret_folder" "infrastructure" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/"
  name             = "infrastructure"
}

resource "infisical_secret_folder" "media" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/"
  name             = "media"
}

resource "infisical_secret_folder" "observability" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/"
  name             = "observability"
}

resource "infisical_secret_folder" "bots" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/"
  name             = "bots"
}

# infrastructure subfolders
resource "infisical_secret_folder" "cert_manager" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/infrastructure"
  name             = "cert-manager"

  depends_on = [infisical_secret_folder.infrastructure]
}

resource "infisical_secret_folder" "tailscale" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/infrastructure"
  name             = "tailscale"

  depends_on = [infisical_secret_folder.infrastructure]
}

resource "infisical_secret_folder" "tunnels" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/infrastructure"
  name             = "tunnels"

  depends_on = [infisical_secret_folder.infrastructure]
}

# media subfolders
resource "infisical_secret_folder" "sonarr" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/media"
  name             = "sonarr"

  depends_on = [infisical_secret_folder.media]
}

resource "infisical_secret_folder" "radarr" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/media"
  name             = "radarr"

  depends_on = [infisical_secret_folder.media]
}

resource "infisical_secret_folder" "prowlarr" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/media"
  name             = "prowlarr"

  depends_on = [infisical_secret_folder.media]
}

# observability subfolders
resource "infisical_secret_folder" "grafana" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/observability"
  name             = "grafana"

  depends_on = [infisical_secret_folder.observability]
}

# bots subfolders
resource "infisical_secret_folder" "vaculikovolevevarle" {
  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = "/bots"
  name             = "vaculikovolevevarle"

  depends_on = [infisical_secret_folder.bots]
}
