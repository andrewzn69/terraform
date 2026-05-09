# locals.tf

locals {
  # flatten control plane groups into individual vm objects for resource iteration
  control_plane_vms = flatten([
    for group in var.control_plane_groups : [
      for i in range(group.count) : {
        name              = "${group.name}-${i + 1}"
        vmid              = group.vm_id_start + i
        node_name         = group.node_name
        cpu               = group.cpu
        memory            = group.memory
        disk_size         = group.disk_size
        storage           = group.storage
        cloudinit_storage = group.cloudinit_storage
        bridge            = group.bridge
        ip                = cidrhost(var.node_subnet, group.ip_range_start + i)
      }
    ]
  ])

  # flatten worker groups into individual vm objects for resource iteration
  worker_vms = flatten([
    for group in var.worker_groups : [
      for i in range(group.count) : {
        name              = "${group.name}-${i + 1}"
        vmid              = group.vm_id_start + i
        node_name         = group.node_name
        cpu               = group.cpu
        memory            = group.memory
        disk_size         = group.disk_size
        storage           = group.storage
        cloudinit_storage = group.cloudinit_storage
        bridge            = group.bridge
        data_disk_size    = group.data_disk_size
        data_storage      = group.data_storage
        ip                = cidrhost(var.node_subnet, group.ip_range_start + i)
      }
    ]
  ])

  # deduplicated list of proxmox nodes across all groups
  # used to download the iso once per node rather than once per group
  unique_nodes = distinct(concat(
    [for group in var.control_plane_groups : group.node_name],
    [for group in var.worker_groups : group.node_name]
  ))
}
