# iso.tf - download talos iso to proxmox

resource "proxmox_virtual_environment_download_file" "talos_iso" {
  node_name    = var.proxmox_host
  content_type = "iso"
  datastore_id = "local"
  file_name    = "talos.iso"
  url          = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/nocloud-amd64.iso"
}
