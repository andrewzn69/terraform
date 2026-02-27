# main.tf - talos image factory schematic and urls

resource "talos_image_factory_schematic" "this" {
  schematic = file("${path.module}/schematic.yaml")
}
