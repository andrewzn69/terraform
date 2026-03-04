provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.oci_private_key
  region       = var.region
}

locals {
  kubeconfig   = try(yamldecode(module.oke.kubeconfig), null)
  cluster_host = try(local.kubeconfig.clusters[0].cluster.server, "")
  cluster_ca   = try(base64decode(local.kubeconfig.clusters[0].cluster["certificate-authority-data"]), "")
}

provider "helm" {
  kubernetes {
    host                   = local.cluster_host
    cluster_ca_certificate = local.cluster_ca

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args = [
        "ce", "cluster", "generate-token",
        "--cluster-id", module.oke.cluster_id,
        "--region", var.region
      ]
      env = {
        OCI_CLI_USER        = var.user_ocid
        OCI_CLI_TENANCY     = var.tenancy_ocid
        OCI_CLI_FINGERPRINT = var.fingerprint
        OCI_CLI_KEY_CONTENT = var.oci_private_key
        OCI_CLI_REGION      = var.region
      }
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster_host
  cluster_ca_certificate = local.cluster_ca

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "oci"
    args = [
      "ce", "cluster", "generate-token",
      "--cluster-id", module.oke.cluster_id,
      "--region", var.region
    ]
    env = {
      OCI_CLI_USER        = var.user_ocid
      OCI_CLI_TENANCY     = var.tenancy_ocid
      OCI_CLI_FINGERPRINT = var.fingerprint
      OCI_CLI_KEY_CONTENT = var.oci_private_key
      OCI_CLI_REGION      = var.region
    }
  }
}
