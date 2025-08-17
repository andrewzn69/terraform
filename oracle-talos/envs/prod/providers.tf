terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.14.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
  }
}

provider "oci" {
}

provider "talos" {
}
