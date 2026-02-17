# worker.tf - worker vms

resource "proxmox_virtual_environment_vm" "worker_vm" {
  for_each = { for vm in local.worker_vms : vm.name => vm }

  name      = each.value.name
  node_name = var.proxmox_host
  vm_id     = each.value.vmid
  on_boot   = true

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.memory
  }

  cdrom {
    file_id   = proxmox_virtual_environment_download_file.talos_iso.id
    interface = "ide2"
  }

  disk {
    datastore_id = var.proxmox_storage
    interface    = "scsi0"
    size         = var.worker_disk_size
  }

  disk {
    datastore_id = var.worker_data_storage
    interface    = "scsi1"
    size         = var.worker_data_disk_size
  }

  network_device {
    bridge = var.proxmox_bridge
    model  = "virtio"
  }

  initialization {
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
      network_device,
      description,
    ]
  }
}
