data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "main" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

locals {
  k8s_version_short = trimprefix(var.kubernetes_version, "v")
  node_image_id = [
    for source in data.oci_containerengine_node_pool_option.main.sources :
    source.image_id
    if can(regex("aarch64.*OKE-${replace(local.k8s_version_short, ".", "\\.")}", source.source_name))
  ][0]
}

resource "oci_containerengine_cluster" "main" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  type               = "BASIC_CLUSTER"

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }

  cluster_pod_network_options {
    cni_type = "FLANNEL_OVERLAY"
  }

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.endpoint_subnet_id
  }

  options {
    service_lb_subnet_ids = [var.endpoint_subnet_id]

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }

    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
  }
}

resource "oci_containerengine_node_pool" "workers" {
  cluster_id         = oci_containerengine_cluster.main.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "${var.cluster_name}-workers"
  node_shape         = "VM.Standard.A1.Flex"

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gb
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.node_image_id
    boot_volume_size_in_gbs = var.node_boot_volume_size_gb
  }

  initial_node_labels {
    key   = "oci.oraclecloud.com/custom-k8s-networking"
    value = "true"
  }

  node_config_details {
    size = var.node_count

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.nodes_subnet_id
    }
  }

  node_metadata = {
    user_data = base64encode(templatefile("${path.module}/cloud-init.sh", {
      tailscale_auth_key = var.tailscale_auth_key
      pods_cidr          = var.pods_cidr
      services_cidr      = var.services_cidr
    }))
  }

  ssh_public_key = var.ssh_public_key
}

data "oci_containerengine_node_pool" "workers" {
  node_pool_id = oci_containerengine_node_pool.workers.id
}

resource "oci_core_volume" "worker_block" {
  count               = var.node_count
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "${var.cluster_name}-worker-${count.index}-block"
  size_in_gbs         = var.node_block_volume_size_gb

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }
}

resource "oci_core_volume_attachment" "worker_block" {
  count           = var.node_count
  attachment_type = "paravirtualized"
  instance_id     = data.oci_containerengine_node_pool.workers.nodes[count.index].id
  volume_id       = oci_core_volume.worker_block[count.index].id
  display_name    = "${var.cluster_name}-worker-${count.index}-block-attach"
}

data "oci_containerengine_cluster_kube_config" "main" {
  cluster_id = oci_containerengine_cluster.main.id
  endpoint   = "PUBLIC_ENDPOINT"
}
