# create bucket
resource "oci_objectstorage_bucket" "talos_images" {
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.namespace
  access_type    = "NoPublicAccess"
  versioning     = "Disabled"
}

resource "oci_objectstorage_preauthrequest" "talos_upload" {
  namespace    = var.namespace
  bucket       = oci_objectstorage_bucket.talos_images.name
  name         = "talos-upload-${var.talos_version}"
  object_name  = "oracle-arm64-${var.talos_version}.qcow2"
  access_type  = "ObjectWrite"
  time_expires = "2030-01-01T00:00:00Z"
}

resource "null_resource" "upload_talos_image" {
  triggers = {
    disk_image_url = var.disk_image_url
  }

  provisioner "local-exec" {
    command = <<-EOT
      tmp=$(mktemp)
      curl -fSL '${var.disk_image_url}' -o "$tmp"
      curl -fSL -X PUT \
        -H 'Content-Type: application/octet-stream' \
        --data-binary @"$tmp" 'https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.talos_upload.access_uri}'
      rm -f "$tmp"
    EOT
  }

  depends_on = [oci_objectstorage_preauthrequest.talos_upload]
}

resource "oci_core_image" "talos" {
  compartment_id = var.compartment_id
  display_name   = "talos-oracle-arm64-${var.talos_version}"

  image_source_details {
    source_type              = "objectStorageTuple"
    bucket_name              = oci_objectstorage_bucket.talos_images.name
    namespace_name           = var.namespace
    object_name              = "oracle-arm64-${var.talos_version}.qcow2"
    operating_system         = "Talos"
    operating_system_version = var.talos_version
    source_image_type        = "QCOW2"
  }

  depends_on = [null_resource.upload_talos_image]
}
