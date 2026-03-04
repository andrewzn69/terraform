# providers.tf - provider configuration for oracle cloud and kubernetes
# configures oci provider with api key auth and helm/k8s providers with oci cli exec auth

# oracle cloud infrastructure provider
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.oci_private_key
  region       = var.region
}

# parse kubeconfig from oke module output for provider configuration
locals {
  kubeconfig   = try(yamldecode(module.oke.kubeconfig), null)
  cluster_host = try(local.kubeconfig.clusters[0].cluster.server, "")
  cluster_ca   = try(base64decode(local.kubeconfig.clusters[0].cluster["certificate-authority-data"]), "")
}

# helm provider configured to use oci cli for authentication
# exec block generates short-lived tokens for cluster access
provider "helm" {
  kubernetes = {
    host                   = local.cluster_host
    cluster_ca_certificate = local.cluster_ca

    exec = {
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

# kubernetes provider configured to use oci cli for authentication
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
