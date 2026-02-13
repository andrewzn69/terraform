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

  all_vms = concat(local.control_plane_vms, local.worker_vms)

  control_plane_private_ipv4_list = [
    for vm in local.control_plane_vms : proxmox_vm_qemu.control_plane_vm[vm.name].default_ipv4_address
  ]

  cluster_api_host_public = var.cluster_api_host != null ? var.cluster_api_host : var.cluster_endpoint

  bootstrap_endpoint = proxmox_vm_qemu.control_plane_vm[local.control_plane_vms[0].name].default_ipv4_address

  total_memory_mb = (var.control_plane_vm_count * var.control_plane_memory) + ((var.number_of_vms - var.control_plane_vm_count) * var.worker_memory)
}

resource "null_resource" "validate_resources" {
  lifecycle {
    precondition {
      condition     = local.total_memory_mb <= 16384
      error_message = "Total VM memory (${local.total_memory_mb}MB) exceeds limit"
    }
  }
}
