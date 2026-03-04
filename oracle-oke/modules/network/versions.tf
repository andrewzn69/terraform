# versions.tf - provider requirements

terraform {
  required_version = ">=1.14.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "8.3.0"
    }
  }
}
