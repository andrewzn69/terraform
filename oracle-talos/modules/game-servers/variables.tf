variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

variable "network_load_balancer_id" {
  description = "The OCID of the network load balancer"
  type        = string
}

variable "worker_instance_ids" {
  description = "List of worker instance OCIDs to register as backends"
  type        = list(string)
}

# backend set policy (shared)
variable "backend_set_policy" {
  description = "Policy for backend sets"
  type        = string
  default     = "TWO_TUPLE"
}

# terraria backend set vars
variable "terraria_health_checker_protocol" {
  description = "Protocol for terraria health checker"
  type        = string
  default     = "TCP"
}

variable "terraria_health_checker_interval_in_millis" {
  description = "Interval in milliseconds for terraria health checker"
  type        = number
  default     = 10000
}

variable "terraria_health_checker_port" {
  description = "Port for terraria health checker"
  type        = number
  default     = 30777
}

variable "terraria_backend_set_name" {
  description = "Name for terraria backend set"
  type        = string
  default     = "terraria"
}

variable "terraria_backend_set_is_preserve_source" {
  description = "Whether to preserve source for terraria backend set"
  type        = bool
  default     = false
}

variable "terraria_backend_port" {
  description = "Port on worker nodes for terraria traffic"
  type        = number
  default     = 30777
}

# terraria listener vars
variable "terraria_listener_name" {
  description = "Name for terraria listener"
  type        = string
  default     = "terraria"
}

variable "terraria_listener_port" {
  description = "Port for terraria listener"
  type        = number
  default     = 7777
}

variable "terraria_listener_protocol" {
  description = "Protocol for terraria listener"
  type        = string
  default     = "TCP"
}
