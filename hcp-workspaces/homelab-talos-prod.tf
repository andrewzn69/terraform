# homelab-talos-prod.tf - workspace and vars

resource "tfe_agent_pool" "homelab" {
  name         = "homelab"
  organization = "zemn"
}

resource "tfe_workspace" "homelab_talos_prod" {
  name              = "homelab-talos-prod"
  organization      = "zemn"
  working_directory = "homelab-talos-proxmox/envs/prod"
  trigger_prefixes  = ["homelab-talos-proxmox/"]

  vcs_repo {
    identifier                 = "andrewzn69/terraform"
    branch                     = "master"
    github_app_installation_id = var.github_app_installation_id
  }
}

resource "tfe_workspace_settings" "homelab_talos_prod" {
  workspace_id   = tfe_workspace.homelab_talos_prod.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool.homelab.id
}

data "tfe_workspace" "seed" {
  name         = "hcp-workspaces"
  organization = "zemn"
}

resource "tfe_run_trigger" "homelab_talos_prod" {
  workspace_id  = tfe_workspace.homelab_talos_prod.id
  sourceable_id = data.tfe_workspace.seed.id
}

# --- proxmox ---

resource "tfe_variable" "proxmox_host_ip" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_host_ip"
  value        = "192.168.1.50"
  category     = "terraform"
}

resource "tfe_variable" "proxmox_host" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_host"
  value        = "proxmox"
  category     = "terraform"
}

resource "tfe_variable" "proxmox_storage" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_storage"
  value        = "local-lvm"
  category     = "terraform"
}

resource "tfe_variable" "cloudinit_storage" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "cloudinit_storage"
  value        = "local-lvm"
  category     = "terraform"
}

resource "tfe_variable" "proxmox_bridge" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_bridge"
  value        = "vmbr0"
  category     = "terraform"
}

resource "tfe_variable" "proxmox_token_id" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_token_id"
  value        = var.proxmox_token_id
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "proxmox_token_secret" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "proxmox_token_secret"
  value        = var.proxmox_token_secret
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

# --- networking ---

resource "tfe_variable" "gateway_ip" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "gateway_ip"
  value        = "192.168.1.1"
  category     = "terraform"
}

resource "tfe_variable" "node_subnet" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "node_subnet"
  value        = "192.168.1.0/24"
  category     = "terraform"
}

resource "tfe_variable" "ip_range_start" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "ip_range_start"
  value        = "10"
  category     = "terraform"
}

# --- vms ---

resource "tfe_variable" "number_of_vms" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "number_of_vms"
  value        = "3"
  category     = "terraform"
}

resource "tfe_variable" "control_plane_vm_count" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "control_plane_vm_count"
  value        = "1"
  category     = "terraform"
}

resource "tfe_variable" "control_plane_cpu" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "control_plane_cpu"
  value        = "2"
  category     = "terraform"
}

resource "tfe_variable" "control_plane_memory" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "control_plane_memory"
  value        = "2048"
  category     = "terraform"
}

resource "tfe_variable" "control_plane_disk_size" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "control_plane_disk_size"
  value        = "20"
  category     = "terraform"
}

resource "tfe_variable" "worker_cpu" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "worker_cpu"
  value        = "2"
  category     = "terraform"
}

resource "tfe_variable" "worker_memory" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "worker_memory"
  value        = "6656"
  category     = "terraform"
}

resource "tfe_variable" "worker_disk_size" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "worker_disk_size"
  value        = "20"
  category     = "terraform"
}

resource "tfe_variable" "worker_data_storage" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "worker_data_storage"
  value        = "storage-vm-disks"
  category     = "terraform"
}

resource "tfe_variable" "worker_data_disk_size" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "worker_data_disk_size"
  value        = "50"
  category     = "terraform"
}

# --- talos ---

resource "tfe_variable" "talos_version" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "talos_version"
  value        = "v1.12.3"
  category     = "terraform"
}

resource "tfe_variable" "kubernetes_version" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "kubernetes_version"
  value        = "v1.35.0"
  category     = "terraform"
}

# --- cluster ---

resource "tfe_variable" "cluster_name" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "cluster_name"
  value        = "vizima"
  category     = "terraform"
}

resource "tfe_variable" "cluster_endpoint" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "cluster_endpoint"
  value        = "https://192.168.1.10:6443"
  category     = "terraform"
}

resource "tfe_variable" "tailscale_auth_key" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "tailscale_auth_key"
  value        = var.tailscale_auth_key
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "cilium_version" {
  workspace_id = tfe_workspace.homelab_talos_prod.id
  key          = "cilium_version"
  value        = "1.19.1"
  category     = "terraform"
}
