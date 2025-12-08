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

variable "subnet_dns_label" {
  description = "DNS label for the subnet"
  type        = string
  default     = "talossubnet"
}

# network load balancer vars
variable "network_load_balancer_display_name" {
  description = "Display name for the network load balancer"
  type        = string
  default     = "controlplane-lb"
}

variable "network_load_balancer_is_preserve_source_destination" {
  description = "Whether to preserve source destination"
  type        = bool
  default     = false
}

variable "network_load_balancer_is_private" {
  description = "Whether the load balancer is private"
  type        = bool
  default     = false
}

# backend set policy (shared)
variable "backend_set_policy" {
  description = "Policy for backend sets"
  type        = string
  default     = "TWO_TUPLE"
}

# talos backend set vars
variable "talos_health_checker_protocol" {
  description = "Protocol for talos health checker"
  type        = string
  default     = "TCP"
}

variable "talos_health_checker_interval_in_millis" {
  description = "Interval in milliseconds for talos health checker"
  type        = number
  default     = 10000
}

variable "talos_health_checker_port" {
  description = "Port for talos health checker"
  type        = number
  default     = 50000
}

variable "talos_backend_set_name" {
  description = "Name for talos backend set"
  type        = string
  default     = "talos"
}

variable "talos_backend_set_is_preserve_source" {
  description = "Whether to preserve source for talos backend set"
  type        = bool
  default     = false
}

# controlplane backend set vars
variable "controlplane_health_checker_protocol" {
  description = "Protocol for controlplane health checker"
  type        = string
  default     = "HTTPS"
}

variable "controlplane_health_checker_interval_in_millis" {
  description = "Interval in milliseconds for controlplane health checker"
  type        = number
  default     = 10000
}

variable "controlplane_health_checker_port" {
  description = "Port for controlplane health checker"
  type        = number
  default     = 6443
}

variable "controlplane_health_checker_return_code" {
  description = "Return code for controlplane health checker"
  type        = number
  default     = 401
}

variable "controlplane_health_checker_url_path" {
  description = "URL path for controlplane health checker"
  type        = string
  default     = "/readyz"
}

variable "controlplane_backend_set_name" {
  description = "Name for controlplane backend set"
  type        = string
  default     = "controlplane"
}

variable "controlplane_backend_set_is_preserve_source" {
  description = "Whether to preserve source for controlplane backend set"
  type        = bool
  default     = false
}

# talos listener vars
variable "talos_listener_name" {
  description = "Name for talos listener"
  type        = string
  default     = "talos"
}

variable "talos_listener_port" {
  description = "Port for talos listener"
  type        = number
  default     = 50000
}

variable "talos_listener_protocol" {
  description = "Protocol for talos listener"
  type        = string
  default     = "TCP"
}

# controlplane listener vars
variable "controlplane_listener_name" {
  description = "Name for controlplane listener"
  type        = string
  default     = "controlplane"
}

variable "controlplane_listener_port" {
  description = "Port for controlplane listener"
  type        = number
  default     = 6443
}

variable "controlplane_listener_protocol" {
  description = "Protocol for controlplane listener"
  type        = string
  default     = "TCP"
}

# minecraft backend set vars
# variable "minecraft_health_checker_protocol" {
#   description = "Protocol for minecraft health checker"
#   type        = string
#   default     = "TCP"
# }
#
# variable "minecraft_health_checker_interval_in_millis" {
#   description = "Interval in milliseconds for minecraft health checker"
#   type        = number
#   default     = 10000
# }
#
# variable "minecraft_health_checker_port" {
#   description = "Port for minecraft health checker"
#   type        = number
#   default     = 31142
# }
#
# variable "minecraft_backend_set_name" {
#   description = "Name for minecraft backend set"
#   type        = string
#   default     = "minecraft"
# }
#
# variable "minecraft_backend_set_is_preserve_source" {
#   description = "Whether to preserve source for minecraft backend set"
#   type        = bool
#   default     = false
# }
#
# # minecraft listener vars
# variable "minecraft_listener_name" {
#   description = "Name for minecraft listener"
#   type        = string
#   default     = "minecraft"
# }
#
# variable "minecraft_listener_port" {
#   description = "Port for minecraft listener"
#   type        = number
#   default     = 25565
# }
#
# variable "minecraft_listener_protocol" {
#   description = "Protocol for minecraft listener"
#   type        = string
#   default     = "TCP"
# }
