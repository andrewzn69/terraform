# locals.tf

locals {
  talos_installer_image = var.installer_image
  bootstrap_endpoint    = var.control_plane_ips[0]
}
