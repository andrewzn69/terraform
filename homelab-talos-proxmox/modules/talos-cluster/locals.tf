# locals.tf - derived values computed from variables and vm resources

locals {
  worker_vm_count = var.number_of_vms - var.control_plane_vm_count

  control_plane_vms = [
    for i in range(var.control_plane_vm_count) : {
      name   = "talos-controlplane-${i + 1}"
      vmid   = var.control_plane_vm_id_start + i
      role   = "control-plane"
      cpu    = var.control_plane_cpu
      memory = var.control_plane_memory
      ip     = cidrhost(var.node_subnet, var.ip_range_start + i)
    }
  ]

  worker_vms = [
    for i in range(local.worker_vm_count) : {
      name   = "talos-worker-${i + 1}"
      vmid   = var.worker_vm_id_start + i
      cpu    = var.worker_cpu
      memory = var.worker_memory
      ip     = cidrhost(var.node_subnet, var.ip_range_start + var.control_plane_vm_count + i)
    }
  ]

  control_plane_private_ipv4_list = [
    for vm in local.control_plane_vms : vm.ip
  ]

  cluster_api_host_public = var.cluster_api_host != null ? var.cluster_api_host : var.cluster_endpoint

  bootstrap_endpoint = local.control_plane_vms[0].ip

  total_memory_mb = (var.control_plane_vm_count * var.control_plane_memory) + ((var.number_of_vms - var.control_plane_vm_count) * var.worker_memory)
}

resource "terraform_data" "validate_resources" {
  lifecycle {
    precondition {
      condition     = local.total_memory_mb <= 16384
      error_message = "Total VM memory (${local.total_memory_mb}MB) exceeds limit"
    }
  }
}
