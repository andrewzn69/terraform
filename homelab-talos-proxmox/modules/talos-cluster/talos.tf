# talos.tf - talos machine secrets, config generation, apply, bootstrap and kubeconfig

resource "talos_image_factory_schematic" "this" {
  schematic = file("${path.module}/schematic.yaml")
}

locals {
  talos_installer_image = "factory.talos.dev/nocloud-installer/${talos_image_factory_schematic.this.id}:${var.talos_version}"
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "control_plane" {
  talos_version      = var.talos_version
  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  kubernetes_version = var.kubernetes_version
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  docs               = false
  examples           = false
}

data "talos_machine_configuration" "worker" {
  talos_version      = var.talos_version
  cluster_name       = var.cluster_name
  cluster_endpoint   = var.cluster_endpoint
  kubernetes_version = var.kubernetes_version
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  docs               = false
  examples           = false
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [local.cluster_api_host_public]
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each                    = { for vm in local.control_plane_vms : vm.name => vm }
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane.machine_configuration
  node                        = each.value.ip

  config_patches = [
    templatefile("${path.module}/patches/controlplane.yaml.tpl", {
      installer_image = local.talos_installer_image
      node_subnet     = var.node_subnet
    }),
    var.tailscale_auth_key != "" ? templatefile("${path.module}/patches/tailscale.yaml.tpl", {
      auth_key    = var.tailscale_auth_key
      node_subnet = var.node_subnet
    }) : ""
  ]

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

resource "talos_machine_configuration_apply" "worker" {
  for_each                    = { for vm in local.worker_vms : vm.name => vm }
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.value.ip

  config_patches = [
    templatefile("${path.module}/patches/worker.yaml.tpl", {
      installer_image = local.talos_installer_image
      node_subnet     = var.node_subnet
    }),
    var.tailscale_auth_key != "" ? templatefile("${path.module}/patches/tailscale.yaml.tpl", {
      auth_key    = var.tailscale_auth_key
      node_subnet = var.node_subnet
    }) : ""
  ]

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

resource "talos_machine_bootstrap" "this" {
  count                = var.control_plane_vm_count > 0 ? 1 : 0
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = local.bootstrap_endpoint
  node                 = local.bootstrap_endpoint

  depends_on = [talos_machine_configuration_apply.control_plane]

  timeouts = {
    create = "10m"
    update = "10m"
  }
}

resource "talos_cluster_kubeconfig" "this" {
  count                = var.control_plane_vm_count > 0 ? 1 : 0
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.bootstrap_endpoint

  depends_on = [talos_machine_bootstrap.this]
}
