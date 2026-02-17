# control_plane.tf - control plane vms
resource "proxmox_virtual_environment_vm" "control_plane_vm" {
  for_each = { for vm in local.control_plane_vms : vm.name => vm }

  name      = each.value.name
  node_name = var.proxmox_host
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
    file_id   = proxmox_virtual_environment_download_file.talos_iso.id
    interface = "ide0"
  }

  disk {
    datastore_id = var.proxmox_storage
    interface    = "scsi0"
    size         = var.control_plane_disk_size
  }

  network_device {
    bridge = var.proxmox_bridge
    model  = "virtio"
  }

  initialization {
    datastore_id = var.cloudinit_storage
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
      description,
    ]
  }
}
