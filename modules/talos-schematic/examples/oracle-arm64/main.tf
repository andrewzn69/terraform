terraform {
  required_version = "~> 1.15"

  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.11.0"
    }
  }
}

provider "talos" {}

module "talos_schematic" {
  source = "../../"

  talos_version = var.talos_version
  platform      = "oracle"
  architecture  = "arm64"
  secureboot    = false
}

output "schematic_id" { value = module.talos_schematic.schematic_id }
output "disk_image_url" { value = module.talos_schematic.disk_image_url }
output "installer_image" { value = module.talos_schematic.installer_image }
