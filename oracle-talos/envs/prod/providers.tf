terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "7.27.0"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0"
    }
  }
}

provider "oci" {
}

provider "talos" {
}
