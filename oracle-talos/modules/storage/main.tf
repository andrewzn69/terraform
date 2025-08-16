resource "oci_objectstorage_bucket" "talos_images" {
  # REQUIRED
  compartment_id = var.compartment_id
  name           = var.bucket_name
  namespace      = var.namespace

  # OPTIONAL
  access_type = var.access_type
  versioning  = var.bucket_versioning
  # access_type = var.bucket_access_type
  # auto_tiering          = var.bucket_auto_tiering
  # defined_tags          = { "Operations.CostCenter" = "42" }
  # freeform_tags         = { "Department" = "Finance" }
  # kms_key_id            = oci_kms_key.test_key.id
  # metadata              = var.bucket_metadata
  # object_events_enabled = var.bucket_object_events_enabled
  # storage_tier          = var.bucket_storage_tier
  # retention_rules {
  #   display_name = var.retention_rule_display_name
  #   duration {
  #     # required
  #     time_amount = var.retention_rule_duration_time_amount
  #     time_unit   = var.retention_rule_duration_time_unit
  #   }
  #   time_rule_locked = var.retention_rule_time_rule_locked
  # }
  # versioning = var.bucket_versioning
}

resource "oci_objectstorage_object" "talos_image" {
  #  REQUIRED
  bucket    = oci_objectstorage_bucket.talos_images.name
  namespace = var.namespace
  object    = var.image_object_name
  source    = var.image_source_path

  # OPTIONAL
  content_type = var.content_type
  # cache_control              = var.object_cache_control
  # content_disposition        = var.object_content_disposition
  # content_encoding           = var.object_content_encoding
  # content_language           = var.object_content_language
  # content_type               = var.object_content_type
  # delete_all_object_versions = var.object_delete_all_object_versions
  # metadata                   = var.object_metadata
  # storage_tier               = var.object_storage_tier
  # opc_sse_kms_key_id         = var.object_opc_sse_kms_key_id
}

resource "oci_core_image" "talos_image" {
  # REQUIRED
  compartment_id = var.compartment_id

  # OPTIONAL
  display_name = var.image_display_name
  # launch_mode  = var.image_launch_mode

  image_source_details {
    source_type    = "objectStorageTuple"
    bucket_name    = oci_objectstorage_bucket.talos_images.name
    namespace_name = var.namespace
    object_name    = oci_objectstorage_object.talos_image.object # exported image name

    # OPTIONAL
    operating_system         = var.image_operating_system
    operating_system_version = var.image_operating_system_version
    source_image_type        = var.source_image_type
  }
}
