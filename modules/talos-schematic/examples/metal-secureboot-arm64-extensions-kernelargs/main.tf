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
  platform             = "metal"
  architecture         = "arm64"
  secureboot           = true
  schematic_extensions = var.schematic_extensions
  extra_kernel_args    = var.extra_kernel_args
}

output "schematic_id" { value = module.talos_schematic.schematic_id }
output "iso_url" { value = module.talos_schematic.iso_url }
output "installer_image" { value = module.talos_schematic.installer_image }
