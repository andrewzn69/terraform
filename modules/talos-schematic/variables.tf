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

  validation {
    condition     = var.bootloader == null || contains(["sd-boot", "grub", "dual-boot"], var.bootloader)
    error_message = "bootloader must be one of: sd-boot, grub, dual-boot"
  }
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

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+", var.talos_version))
    error_message = "talos_version must start with vX.Y.Z"
  }
}
