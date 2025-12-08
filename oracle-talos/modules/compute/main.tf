terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

locals {
  cluster_endpoint_url = var.cluster_endpoint
}

# talos machine secrets (shared across all nodes)
resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

# base controlplane machine config (single config for all controlplanes)
data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = local.cluster_endpoint_url
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    yamlencode({
      machine = {
        certSANs = [
          var.load_balancer_ip
        ]
        install = {
          extensions = [{
            image = "factory.talos.dev/installer/${var.talos_factory_schematic_id}:${var.talos_version}"
          }]
        }
      }
      cluster = {
        apiServer = {
          certSANs = [
            var.load_balancer_ip
          ]
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = [
        "TS_AUTHKEY=${var.tailscale_auth_key}"
      ]
    })
  ]
}

# base worker config (single config for all workers)
data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = local.cluster_endpoint_url
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    yamlencode({
      machine = {
        certSANs = [
          var.load_balancer_ip
        ]
        install = {
          extensions = [{
            image = "factory.talos.dev/installer/${var.talos_factory_schematic_id}:${var.talos_version}"
          }]
        }
      }
    }),
    yamlencode({
      apiVersion = "v1alpha1"
      kind       = "ExtensionServiceConfig"
      name       = "tailscale"
      environment = [
        "TS_AUTHKEY=${var.tailscale_auth_key}"
      ]
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [var.load_balancer_ip]
}

# availability domains
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

# controlplane instances
resource "oci_core_instance" "controlplane" {
  count = var.controlplane_count

  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "${var.cluster_name}-controlplane-${count.index}"
  shape               = var.instance_shape

  shape_config {
    memory_in_gbs = var.controlplane_memory_gb
    ocpus         = var.controlplane_ocpus
  }

  create_vnic_details {
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    private_ip       = cidrhost(var.subnet_cidr, var.controlplane_base_ip_offset + count.index)
    subnet_id        = var.subnet_id
    hostname_label   = "${var.cluster_name}-controlplane-${count.index}"
  }

  source_details {
    source_id   = var.custom_image_id
    source_type = "image"
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = { user_data = base64encode(data.talos_machine_configuration.controlplane.machine_configuration) }

  preserve_data_volumes_created_at_launch = false
}

# worker instances
resource "oci_core_instance" "worker" {
  count = var.worker_count

  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "${var.cluster_name}-worker-${count.index}"
  shape               = var.instance_shape

  shape_config {
    memory_in_gbs = var.worker_memory_gb
    ocpus         = var.worker_ocpus
  }

  create_vnic_details {
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    private_ip       = cidrhost(var.subnet_cidr, var.worker_base_ip_offset + count.index)
    subnet_id        = var.subnet_id
    hostname_label   = "${var.cluster_name}-worker-${count.index}"
  }

  source_details {
    source_id               = var.custom_image_id
    source_type             = "image"
    boot_volume_size_in_gbs = var.worker_boot_volume_size_gb
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = { user_data = base64encode(data.talos_machine_configuration.worker.machine_configuration) }

  preserve_data_volumes_created_at_launch = false

  # launch_volume_attachments {
  #   type = var.instance_launch_volume_attachments_type
  #   launch_create_volume_details {
  #     size_in_gbs          = var.instance_launch_volume_attachments_launch_create_volume_details_size_in_gbs
  #     volume_creation_type = var.instance_launch_volume_attachments_launch_create_volume_details_volume_creation_type
  #   }
  # }
}

# apply controlplane config to each node
# Commented out: Cannot connect to instance public IPs because certs only have LB IP
# Config is applied via user_data instead
# resource "talos_machine_configuration_apply" "controlplane" {
#   count = var.controlplane_count
#
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
#   endpoint                    = oci_core_instance.controlplane[count.index].public_ip
#   node                        = oci_core_instance.controlplane[count.index].private_ip
#
#   config_patches = [
#     yamlencode({
#       machine = {
#         network = {
#           hostname = "${var.cluster_name}-controlplane-${count.index}"
#         }
#         certSANs = [
#           oci_core_instance.controlplane[count.index].private_ip,
#           oci_core_instance.controlplane[count.index].public_ip
#         ]
#       }
#     }),
#     yamlencode({
#       apiVersion = "v1alpha1"
#       kind       = "ExtensionServiceConfig"
#       name       = "tailscale"
#       environment = [
#         "TS_AUTHKEY=${var.tailscale_auth_key}",
#         "TS_HOSTNAME=${var.cluster_name}-controlplane-${count.index}"
#       ]
#     })
#   ]
#
#   depends_on = [oci_core_instance.controlplane]
# }

# apply worker configuration to each node
# Commented out: Cannot connect to instance public IPs because certs only have LB IP
# Config is applied via user_data instead
# resource "talos_machine_configuration_apply" "worker" {
#   count = var.worker_count
#
#   client_configuration        = talos_machine_secrets.this.client_configuration
#   machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
#   endpoint                    = oci_core_instance.worker[count.index].public_ip
#   node                        = oci_core_instance.worker[count.index].private_ip
#
#   config_patches = [
#     yamlencode({
#       machine = {
#         network = {
#           hostname = "${var.cluster_name}-worker-${count.index}"
#         }
#         certSANs = [
#           oci_core_instance.worker[count.index].private_ip,
#           oci_core_instance.worker[count.index].public_ip
#         ]
#       }
#     }),
#     yamlencode({
#       apiVersion = "v1alpha1"
#       kind       = "ExtensionServiceConfig"
#       name       = "tailscale"
#       environment = [
#         "TS_AUTHKEY=${var.tailscale_auth_key}",
#         "TS_HOSTNAME=${var.cluster_name}-worker-${count.index}"
#       ]
#     })
#   ]
#
#   depends_on = [oci_core_instance.worker]
# }

# register controlplane backends to talos api load balancer
resource "oci_network_load_balancer_backend" "controlplane_talos" {
  for_each = { for idx, inst in oci_core_instance.controlplane : idx => inst.id }

  backend_set_name         = var.talos_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.talos_backend_port
  target_id                = each.value
}

# register controlplane backends to kubernetes api load balancer
resource "oci_network_load_balancer_backend" "controlplane_k8s" {
  for_each = { for idx, inst in oci_core_instance.controlplane : idx => inst.id }

  backend_set_name         = var.controlplane_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.controlplane_backend_port
  target_id                = each.value
}

# resource "oci_network_load_balancer_backend" "worker_minecraft_backend" {
#   backend_set_name         = var.minecraft_backend_set_name
#   network_load_balancer_id = var.network_load_balancer_id
#   port                     = var.minecraft_backend_port
#   target_id                = oci_core_instance.worker_instance.id
# }

# bootstrap first controlplane node
resource "talos_machine_bootstrap" "controlplane_bootstrap" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.load_balancer_ip
  node                 = oci_core_instance.controlplane[0].private_ip

  depends_on = [
    oci_core_instance.controlplane,
    oci_network_load_balancer_backend.controlplane_talos,
    oci_network_load_balancer_backend.controlplane_k8s
  ]
}

# generate kubeconfig
resource "talos_cluster_kubeconfig" "kubeconfig" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.load_balancer_ip
  node                 = oci_core_instance.controlplane[0].private_ip

  depends_on = [talos_machine_bootstrap.controlplane_bootstrap]
}
