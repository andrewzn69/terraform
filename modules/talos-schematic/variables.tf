# variables.tf

variable "schematic_extensions" {
  description = "List of Talos image factory official extensions to include in the schematic"
  type        = list(string)
  default     = []
}

variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "platform" {
  description = "Target platform"
  type        = string
  default     = null
}

variable "architecture" {
  description = "CPU architecture"
  type        = string

  validation {
    condition     = contains(["amd64", "arm64"], var.architecture)
    error_message = "architecture must be one of: amd64, arm64"
  }
}

variable "sbc" {
  description = "Single board computer target"
  type        = string
  default     = null
}

variable "secureboot" {
  description = "Whether to use Secure Boot enabled images"
  type        = bool
}

variable "extra_kernel_args" {
  description = "Extra kernel command line arguments"
  type        = list(string)
  default     = []
}

variable "bootloader" {
  description = "Bootloader type - sd-boot (UEFI only), grub (BIOS only), dual-boot (BIOS+UEFI), null defaults to auto (recommended)"
  type        = string
  default     = null
}
