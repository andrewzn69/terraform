# environments.tf - creates infisical projects and folder structures for each cluster

# create vizima cluster project
module "vizima" {
  source = "./modules/cluster-environment"

  org_id       = var.org_id
  cluster_name = "vizima"
  project_name = "Vizima"
  project_slug = "vizima"
}

locals {
  folders = {
    infrastructure = {
      path = "/"
      subfolders = {
        cert-manager = {}
        tailscale    = {}
        tunnels      = {}
      }
    }
    media = {
      path = "/"
      subfolders = {
        sonarr   = {}
        radarr   = {}
        prowlarr = {}
      }
    }
    observability = {
      path = "/"
      subfolders = {
        grafana = {}
      }
    }
    bots = {
      path = "/"
      subfolders = {
        vaculikovolevevarle = {}
      }
    }
  }

  # flatten structure for for_each
  all_folders = merge(
    { for k, v in local.folders : k => { path = v.path, parent = null } },
    flatten([
      for parent, config in local.folders : {
        for subfolder in keys(config.subfolders) :
        "${parent}/${subfolder}" => {
          path   = "/${parent}"
          parent = parent
        }
      }
    ])...
  )
}

resource "infisical_secret_folder" "folders" {
  for_each = local.all_folders

  project_id       = module.vizima.project_id
  environment_slug = "prod"
  folder_path      = each.value.path
  name             = split("/", each.key)[length(split("/", each.key)) - 1]

  depends_on = each.value.parent != null ? [infisical_secret_folder.folders[each.value.parent]] : []
}
