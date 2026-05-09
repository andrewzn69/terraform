# control_plane.tf

resource "proxmox_virtual_environment_vm" "control_plane" {
  for_each = { for vm in local.control_plane_vms : vm.name => vm }

  name      = each.value.name
  node_name = each.value.node_name
  vm_id     = each.value.vmid
  on_boot   = true

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
    type  = "host"
  }

  memory {
    dedicated = each.value.memory
  }

  boot_order = ["scsi0", "ide0", "net0"]

  cdrom {
    file_id   = proxmox_virtual_environment_download_file.iso[each.value.node_name].id
    interface = "ide0"
  }

  disk {
    datastore_id = each.value.storage
    interface    = "scsi0"
    size         = each.value.disk_size
  }

  network_device {
    bridge = each.value.bridge
    model  = "virtio"
  }

  initialization {
    datastore_id = each.value.cloudinit_storage
    ip_config {
      ipv4 {
        address = "${each.value.ip}/${split("/", var.node_subnet)[1]}"
        gateway = var.gateway_ip
      }
    }
  }

  lifecycle {
    ignore_changes = [
      cdrom,
      boot_order,
      network_device,
      description
    ]
  }
}
