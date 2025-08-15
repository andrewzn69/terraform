variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

# VCN vars
variable "vcn_cidr_blocks" {
  description = "CIDR block for the VCN"
  type        = string
}

variable "vcn_display_name" {
  description = "Display name for the VCN"
  type        = string
  default     = "talos-vcn"
}

variable "vcn_dns_label" {
  description = "DNS label for the VCN"
  type        = string
  default     = "talosvcn"
}

# internet gateway vars
variable "internet_gateway_enabled" {
  description = "Whether the internet gateway is enabled"
  type        = bool
  default     = true
}

variable "internet_gateway_display_name" {
  description = "Display name for the internet gateway"
  type        = string
  default     = "talos_igw"
}

# route table vars
variable "route_table_display_name" {
  description = "Display name for the route table"
  type        = string
  default     = "talos-route-table"
}

variable "route_table_route_rules_destination" {
  description = "Destination for route rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_table_route_rules_destination_type" {
  description = "Destination type for route rule"
  type        = string
  default     = "CIDR_BLOCK"
}

# security list vars
variable "security_list_display_name" {
  description = "Display name for the security list"
  type        = string
  default     = "talos-security-list"
}

variable "security_list_egress_security_rules_destination" {
  description = "Destination for egress security rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "security_list_egress_security_rules_protocol" {
  description = "Protocol for egress security rule"
  type        = string
  default     = "all"
}

variable "security_list_egress_security_rules_destination_type" {

  description = "Destination type for egress security rule"
  type        = string
  default     = "CIDR_BLOCK"
}

variable "security_list_ingress_security_rules_protocol" {
  description = "Protocol for ingress security rule"
  type        = string
  default     = "all"
}

variable "security_list_ingress_security_rules_source" {
  description = "Source for ingress security rule"
  type        = string
  default     = "0.0.0.0/0"
}

# subnet vars
variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_display_name" {
  description = "Display name for the subnet"
  type        = string
  default     = "talos-subnet"
}
