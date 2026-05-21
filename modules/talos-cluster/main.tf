# talos.tf

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "control_plane" {
  talos_version    = var.talos_version
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  docs             = false
  examples         = false
}

data "talos_machine_configuration" "worker" {
  talos_version    = var.talos_version
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  docs             = false
  examples         = false
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = var.control_plane_ips
}

# index-keyed map so each ip gets a stable key for state tracking
resource "talos_machine_configuration_apply" "control_plane" {
  for_each                    = { for idx, ip in var.control_plane_ips : tostring(idx) => ip }
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.value

  config_patches = concat(
    [
      templatefile("${path.module}/patches/controlplane.yaml.tpl", {
        installer_image = local.talos_installer_image
        node_subnet     = var.node_subnet
        install_disk    = var.install_disk
      })
    ],
    var.extra_control_plane_patches
  )

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

# index-keyed map so each ip gets a stable key for state tracking
resource "talos_machine_configuration_apply" "worker" {
  for_each                    = { for idx, ip in var.worker_ips : tostring(idx) => ip }
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value

  config_patches = concat(
    [
      templatefile("${path.module}/patches/worker.yaml.tpl", {
        installer_image = local.talos_installer_image
        node_subnet     = var.node_subnet
        install_disk    = var.install_disk
      })
    ],
    var.extra_worker_patches
  )

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = local.bootstrap_endpoint
  node                 = local.bootstrap_endpoint

  depends_on = [talos_machine_configuration_apply.control_plane]

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = var.control_plane_ips
  worker_nodes         = var.worker_ips
  endpoints            = var.control_plane_ips

  depends_on = [talos_machine_bootstrap.this]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_endpoint

  depends_on = [data.talos_cluster_health.this]
}
