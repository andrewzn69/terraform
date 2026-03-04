# providers.tf - infisical provider configuration using eu region

provider "infisical" {
  host = "https://eu.infisical.com"

  auth = {
    universal = {
      client_id     = var.infisical_client_id
      client_secret = var.infisical_client_secret
    }
  }
}
