# outputs.tf

output "schematic_id" {
  description = "Talos image factory schematic ID"
  value       = talos_image_factory_schematic.this.id
}

output "iso_url" {
  description = "Talos ISO download URL"
  value       = var.secureboot ? data.talos_image_factory_urls.this.urls.iso_secureboot : data.talos_image_factory_urls.this.urls.iso
}

output "disk_image_url" {
  description = "Talos disk image download URL"
  value       = var.secureboot ? data.talos_image_factory_urls.this.urls.disk_image_secureboot : data.talos_image_factory_urls.this.urls.disk_image
}

output "installer_image" {
  description = "Talos installer OCI image reference"
  value       = var.secureboot ? data.talos_image_factory_urls.this.urls.installer_secureboot : data.talos_image_factory_urls.this.urls.installer
}
