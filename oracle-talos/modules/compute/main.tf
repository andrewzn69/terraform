locals {
  total_memory     = (var.controlplane_count * var.controlplane_memory_gb) + (var.worker_count * var.worker_memory_gb)
  total_ocpus      = (var.controlplane_count * var.controlplane_ocpus) + (var.worker_count * var.worker_ocpus)
  total_storage_gb = ((var.controlplane_count + var.worker_count) * var.boot_volume_size_gb) + (var.worker_count * var.worker_data_volume_size_gb)

  kube_config = {
    host                   = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.host
    client_certificate     = base64decode(talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration.ca_certificate)
  }
}

resource "null_resource" "validate_free_tier" {
  lifecycle {
    precondition {
      condition     = local.total_memory <= var.free_tier_memory_limit
      error_message = "Total memory (${local.total_memory}GB) exceeds free tier limit (${var.free_tier_memory_limit}GB)."
    }

    precondition {
      condition     = local.total_ocpus <= var.free_tier_ocpu_limit
      error_message = "Total OCPUs (${local.total_ocpus}) exceeds free tier limit (${var.free_tier_ocpu_limit})"
    }

    precondition {
      condition     = local.total_storage_gb <= var.free_tier_storage_limit_gb
      error_message = "Total storage (${local.total_storage_gb}GB) exceeds free tier limit (${var.free_tier_storage_limit_gb}GB)."
    }
  }
}

resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    templatefile("${path.module}/patches/controlplane.yaml.tpl", {
      load_balancer_ip    = var.load_balancer_ip
      installer_image_url = var.installer_image_url
      subnet_cidr         = var.subnet_cidr
    }),
    templatefile("${path.module}/patches/tailscale.yaml.tpl", {
      auth_key = var.tailscale_auth_key
    })
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    templatefile("${path.module}/patches/worker.yaml.tpl", {
      load_balancer_ip    = var.load_balancer_ip
      installer_image_url = var.installer_image_url
      subnet_cidr         = var.subnet_cidr
    }),
    templatefile("${path.module}/patches/tailscale.yaml.tpl", {
      auth_key = var.tailscale_auth_key
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [var.load_balancer_ip]
}

data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

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
    assign_public_ip = false
    private_ip       = cidrhost(var.subnet_cidr, var.controlplane_base_ip_offset + count.index)
    subnet_id        = var.subnet_id
    hostname_label   = "${var.cluster_name}-controlplane-${count.index}"
  }

  source_details {
    source_id               = var.custom_image_id
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_size_gb
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    user_data = base64encode(data.talos_machine_configuration.controlplane.machine_configuration)
  }

  preserve_data_volumes_created_at_launch = false
}

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
    assign_public_ip = false
    private_ip       = cidrhost(var.subnet_cidr, var.worker_base_ip_offset + count.index)
    subnet_id        = var.subnet_id
    hostname_label   = "${var.cluster_name}-worker-${count.index}"
  }

  source_details {
    source_id               = var.custom_image_id
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_size_gb
  }

  launch_options {
    network_type = var.instance_launch_options_network_type
  }

  metadata = {
    user_data = base64encode(data.talos_machine_configuration.worker.machine_configuration)
  }

  preserve_data_volumes_created_at_launch = false
}

resource "oci_core_volume" "worker_data" {
  count               = var.worker_count
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  display_name        = "${var.cluster_name}-worker-${count.index}-data"
  size_in_gbs         = var.worker_data_volume_size_gb
}

resource "oci_core_volume_attachment" "worker_data" {
  count           = var.worker_count
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.worker[count.index].id
  volume_id       = oci_core_volume.worker_data[count.index].id
  display_name    = "${var.cluster_name}-worker-${count.index}-data"

  depends_on = [oci_core_instance.worker]
}

resource "oci_network_load_balancer_backend" "controlplane_talos" {
  for_each = { for idx, inst in oci_core_instance.controlplane : idx => inst.id }

  backend_set_name         = var.talos_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.talos_backend_port
  target_id                = each.value
}

resource "oci_network_load_balancer_backend" "controlplane_k8s" {
  for_each = { for idx, inst in oci_core_instance.controlplane : idx => inst.id }

  backend_set_name         = var.controlplane_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.controlplane_backend_port
  target_id                = each.value
}

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

resource "talos_cluster_kubeconfig" "kubeconfig" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.load_balancer_ip
  node                 = oci_core_instance.controlplane[0].private_ip

  depends_on = [talos_machine_bootstrap.controlplane_bootstrap]
}
