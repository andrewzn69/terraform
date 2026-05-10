# iso.tf
# download the os iso to each unique proxmox node

resource "proxmox_download_file" "iso" {
  for_each = toset(local.unique_nodes)

  node_name    = each.value
  content_type = "iso"
  datastore_id = var.iso_datastore_id
  file_name    = basename(var.iso_url)
  url          = var.iso_url
}
