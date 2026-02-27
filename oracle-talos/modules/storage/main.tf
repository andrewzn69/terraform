# create bucket
resource "oci_objectstorage_bucket" "talos_images" {
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.namespace
  access_type    = "NoPublicAccess"
  versioning     = "Disabled"
}

resource "null_resource" "download_talos_image" {
  triggers = {
    disk_image_url = var.disk_image_url
  }

  provisioner "local-exec" {
    command = "curl -L '${var.disk_image_url}' -o /tmp/talos-oracle-arm64.qcow2"
  }
}

resource "oci_objectstorage_object" "talos_image" {
  depends_on   = [null_resource.download_talos_image]
  bucket       = oci_objectstorage_bucket.talos_images.name
  namespace    = var.namespace
  object       = "oracle-arm64-${var.talos_version}.qcow2"
  source       = "/tmp/talos-oracle-arm64.qcow2"
  content_type = "application/octet-stream"
}

resource "oci_core_image" "talos" {
  compartment_id = var.compartment_id
  display_name   = "talos-oracle-arm64-${var.talos_version}"

  image_source_details {
    source_type              = "objectStorageTuple"
    bucket_name              = oci_objectstorage_bucket.talos_images.name
    namespace_name           = var.namespace
    object_name              = oci_objectstorage_object.talos_image.object
    operating_system         = "Talos"
    operating_system_version = var.talos_version
    source_image_type        = "QCOW2"
  }
}
