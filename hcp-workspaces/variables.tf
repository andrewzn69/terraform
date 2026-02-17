# variables.tf - input vars for hcp-workspaces

variable "proxmox_token_secret" {
  description = "Proxmox API token secret for homelab-talos"
  type        = string
  sensitive   = true
}

variable "proxmox_token_id" {
  description = "Proxmox API token ID for homelab-talos"
  type        = string
  sensitive   = true
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key"
  type        = string
  sensitive   = true
}

variable "github_app_installation_id" {
  description = "HCP GitHub App installation ID for VCS connection"
  type        = string
}
