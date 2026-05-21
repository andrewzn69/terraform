# variables.tf

variable "architecture" {
  type        = string
  description = "CPU architecture"

  validation {
    condition     = contains(["amd64", "arm64"], var.architecture)
    error_message = "architecture must be one of: amd64, arm64"
  }
}

variable "bootloader" {
  type        = string
  description = "Bootloader type - sd-boot (UEFI only), grub (BIOS only), dual-boot (BIOS+UEFI), null defaults to auto (recommended)"
  default     = null
}

variable "extra_kernel_args" {
  type        = list(string)
  description = "Extra kernel command line arguments"
  default     = []
}

variable "platform" {
  type        = string
  description = "Target platform"
  default     = null
}

variable "sbc" {
  type        = string
  description = "Single board computer target"
  default     = null
}

variable "schematic_extensions" {
  type        = list(string)
  description = "List of Talos image factory official extensions to include in the schematic"
  default     = []
}

variable "secureboot" {
  type        = bool
  description = "Whether to use Secure Boot enabled images"
}

variable "talos_version" {
  type        = string
  description = "Talos version"
}
