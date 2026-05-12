# schematic.tf

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      extraKernelArgs = var.extra_kernel_args
      bootloader      = var.bootloader
      systemExtensions = {
        officialExtensions = var.schematic_extensions
      }
    }
  })
}

data "talos_image_factory_urls" "this" {
  talos_version = var.talos_version
  schematic_id  = talos_image_factory_schematic.this.id
  architecture  = var.architecture
  platform      = var.platform
  sbc           = var.sbc
}
