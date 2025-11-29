terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

locals {
  cluster_endpoint_url = "https://${var.controlplane_private_ip}:6443"
}

# talos config files
resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = local.cluster_endpoint_url
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    yamlencode({
      machine = {
        certSANs = [
          var.controlplane_private_ip,
          var.load_balancer_ip
        ]
      }
      cluster = {
        apiServer = {
          certSANs = [
            var.load_balancer_ip
          ]
        }
      }
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = [
    yamlencode({
      machine = {
        certSANs = [
          var.worker_private_ip,
          var.load_balancer_ip
        ]
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [var.load_balancer_ip]
}

# vm creation
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

resource "oci_core_instance" "controlplane_instance" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  create_vnic_details {
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    private_ip       = var.controlplane_private_ip
    subnet_id        = var.subnet_id
  }
  display_name = var.controlplane_display_name
  launch_options {
    network_type = var.instance_launch_options_network_type
  }
  metadata = { user_data = base64encode(data.talos_machine_configuration.controlplane.machine_configuration) }
  shape_config {
    memory_in_gbs = var.controlplane_memory_in_gbs
    ocpus         = var.controlplane_ocpus
  }
  source_details {
    source_id   = var.custom_image_id
    source_type = "image"
  }
  preserve_data_volumes_created_at_launch = false
}

resource "oci_core_instance" "worker_instance" {
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  create_vnic_details {
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    private_ip       = var.worker_private_ip
    subnet_id        = var.subnet_id
  }
  display_name = var.worker_display_name
  launch_options {
    network_type = var.instance_launch_options_network_type
  }
  launch_volume_attachments {
    type = var.instance_launch_volume_attachments_type
    launch_create_volume_details {
      size_in_gbs          = var.instance_launch_volume_attachments_launch_create_volume_details_size_in_gbs
      volume_creation_type = var.instance_launch_volume_attachments_launch_create_volume_details_volume_creation_type
    }
  }
  metadata = { user_data = base64encode(data.talos_machine_configuration.worker.machine_configuration) }
  shape_config {
    memory_in_gbs = var.worker_memory_in_gbs
    ocpus         = var.worker_ocpus
  }
  source_details {
    source_id   = var.custom_image_id
    source_type = "image"
  }
  preserve_data_volumes_created_at_launch = false
}

resource "oci_network_load_balancer_backend" "controlplane_talos_backend" {
  backend_set_name         = var.talos_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.talos_backend_port
  target_id                = oci_core_instance.controlplane_instance.id
}

resource "oci_network_load_balancer_backend" "controlplane_controlplane_backend" {
  backend_set_name         = var.controlplane_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.controlplane_backend_port
  target_id                = oci_core_instance.controlplane_instance.id
}

# resource "oci_network_load_balancer_backend" "worker_minecraft_backend" {
#   backend_set_name         = var.minecraft_backend_set_name
#   network_load_balancer_id = var.network_load_balancer_id
#   port                     = var.minecraft_backend_port
#   target_id                = oci_core_instance.worker_instance.id
# }

resource "talos_machine_bootstrap" "controlplane_bootstrap" {
  depends_on = [
    oci_core_instance.controlplane_instance,
    oci_network_load_balancer_backend.controlplane_talos_backend,
    oci_network_load_balancer_backend.controlplane_controlplane_backend
  ]
  node                 = var.load_balancer_ip
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.load_balancer_ip
  depends_on           = [talos_machine_bootstrap.controlplane_bootstrap]
}
