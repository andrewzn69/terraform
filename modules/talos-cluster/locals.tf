# locals.tf

locals {
  talos_installer_image = "factory.talos.dev/nocloud-installer/${talos_image_factory_schematic.this.id}:${var.talos_version}"
  bootstrap_endpoint    = var.control_plane_ips[0]
}
