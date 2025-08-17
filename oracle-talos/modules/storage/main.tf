# create bucket
resource "oci_objectstorage_bucket" "talos_images" {
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.namespace
  access_type    = var.access_type
  versioning     = var.bucket_versioning
}

# impoprt oci into bucket
resource "oci_objectstorage_object" "talos_image" {
  bucket       = oci_objectstorage_bucket.talos_images.name
  namespace    = var.namespace
  object       = var.image_object_name
  source       = var.image_source_path
  content_type = var.content_type
}

# make image out of the oci
resource "oci_core_image" "talos_image" {
  compartment_id = var.compartment_id
  display_name   = var.image_display_name
  image_source_details {
    source_type              = "objectStorageTuple"
    bucket_name              = oci_objectstorage_bucket.talos_images.name
    namespace_name           = var.namespace
    object_name              = oci_objectstorage_object.talos_image.object # exported image name
    operating_system         = var.image_operating_system
    operating_system_version = var.image_operating_system_version
    source_image_type        = var.source_image_type
  }
}
