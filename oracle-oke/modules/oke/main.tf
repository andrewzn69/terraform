data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "oke_node_image" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"

  filter {
    name   = "display_name"
    values = [".*OKE-${replace(trimprefix(var.kubernetes_version, "v"), ".", "\\.")}.*"]
    regex  = true
  }
}

resource "oci_containerengine_cluster" "main" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  type               = "BASIC_CLUSTER"

  cluster_pod_network_options {
    cni_type = "FLANNEL_OVERLAY"
  }

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.subnet_id
  }

  options {
    service_lb_subnet_ids = [var.subnet_id]

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

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_gb
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = data.oci_core_images.oke_node_image.images[0].id
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
      subnet_id           = var.subnet_id
    }
  }

  node_metadata = {
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      tailscale_auth_key = var.tailscale_auth_key
      pods_cidr          = var.pods_cidr
      services_cidr      = var.services_cidr
    }))
  }

  ssh_public_key = var.ssh_public_key
}

data "oci_containerengine_node_pool_nodes" "workers" {
  node_pool_id = oci_containerengine_node_pool.workers.id
}

resource "oci_core_volume" "worker_block" {
  count               = var.node_count
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "${var.cluster_name}-worker-${count.index}-block"
  size_in_gbs         = var.node_block_volume_size_gb
}

resource "oci_core_volume_attachment" "worker_block" {
  count           = var.node_count
  attachment_type = "paravirtualized"
  instance_id     = data.oci_containerengine_node_pool_nodes.workers.nodes[count.index].id
  volume_id       = oci_core_volume.worker_block[count.index].id
  display_name    = "${var.cluster_name}-worker-${count.index}-block-attach"
}

data "oci_containerengine_cluster_kube_config" "main" {
  cluster_id    = oci_containerengine_cluster.main.id
  endpoint      = "PUBLIC_ENDPOINT"
  token_version = "2.0.0"
}
