output "bucket_name" {
  description = "Name of the created bucket"
  value       = oci_objectstorage_bucket.talos_images.name
}

output "bucket_id" {
  description = "OCID of the created bucket"
  value       = oci_objectstorage_bucket.talos_images.id
}

output "bucket_namespace" {
  description = "Namespace of the bucket"
  value       = oci_objectstorage_bucket.talos_images.namespace
}

output "object_name" {
  description = "Name of the uploaded object"
  value       = "oracle-arm64-${var.talos_version}.qcow2"
}

output "custom_image_id" {
  description = "OCID of the custom Talos image"
  value       = oci_core_image.talos.id
}
