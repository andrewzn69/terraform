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
  value       = oci_objectstorage_object.talos_image.object
}

output "custom_image_id" {
  description = "OCID of the custom Talos image"
  value       = oci_core_image.talos_image.id
}

output "object_url" {
  description = "URL of the uploaded object"
  value       = "https://objectstorage.${oci_objectstorage_bucket.talos_images.namespace}.oraclecloud.com/n/${oci_objectstorage_bucket.talos_images.namespace}/b/${oci_objectstorage_bucket.talos_images.name}/o/${oci_objectstorage_object.talos_image.object}"
}

