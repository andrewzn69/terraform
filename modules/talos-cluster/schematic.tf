# schematic.tf

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      systemExtensions = {
        officialExtensions = var.schematic_extensions
      }
    }
  })
}
