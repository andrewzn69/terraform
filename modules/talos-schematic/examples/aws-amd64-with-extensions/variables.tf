variable "talos_version" {
  description = "Talos version"
  type        = string
}

variable "schematic_extensions" {
  description = "List of Talos image factory official extensions"
  type        = list(string)
  default     = []
}
