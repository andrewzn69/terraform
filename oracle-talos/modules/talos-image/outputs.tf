# outputs.tf - talos image factory urls

output "schematic_id" {
  description = "Talos image factory schematic ID"
  value       = talos_image_factory_schematic.this.id
}

output "disk_image_url" {
  description = "QCOW2 disk image URL for Oracle Cloud import"
  value       = "https://factory.talos.dev/image/${talos_image_factory_schematic.this.id}/${var.talos_version}/oracle-arm64.qcow2"
}

output "installer_url" {
  value       = "https://factory.talos.dev/installer/${talos_image_factory_schematic.this.id}:${var.talos_version}"
  description = "Installer image URL for Talos upgrades"
}
