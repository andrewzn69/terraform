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

  talos_version        = var.talos_version
  platform             = "aws"
  architecture         = "amd64"
  secureboot           = false
  schematic_extensions = var.schematic_extensions
}

output "schematic_id" { value = module.talos_schematic.schematic_id }
output "disk_image_url" { value = module.talos_schematic.disk_image_url }
output "installer_image" { value = module.talos_schematic.installer_image }
