provider "proxmox" {
  endpoint  = "https://${var.proxmox_host_ip}:8006/"
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
  insecure  = true
}

provider "helm" {}
