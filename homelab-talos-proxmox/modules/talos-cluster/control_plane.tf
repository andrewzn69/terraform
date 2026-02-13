# control plane vms - one per control plane node
resource "proxmox_vm_qemu" "control_plane_vm" {
  for_each = { for vm in local.control_plane_vms : vm.name => vm }

  vmid        = each.value.vmid
  name        = each.value.name
  target_node = var.proxmox_host
  agent       = 1
  bootdisk    = "scsi0"
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  ipconfig0   = "ip=${each.value.ip}/24,gw=${var.gateway_ip}"

  cpu {
    cores = each.value.cpu
  }
  memory = each.value.memory

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.proxmox_storage
          size    = var.control_plane_disk_size
        }
      }
      scsi1 {
        cloudinit {
          storage = var.proxmox_storage
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso_path
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.proxmox_bridge
  }

  lifecycle {
    ignore_changes = [
      disk,
      network,
      desc
    ]
    prevent_destroy = false
  }
}
