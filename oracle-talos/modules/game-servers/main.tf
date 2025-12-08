# terraria backend set
resource "oci_network_load_balancer_backend_set" "terraria" {
  health_checker {
    protocol           = var.terraria_health_checker_protocol
    interval_in_millis = var.terraria_health_checker_interval_in_millis
    port               = var.terraria_health_checker_port
  }
  name                     = var.terraria_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  policy                   = var.backend_set_policy
  is_preserve_source       = var.terraria_backend_set_is_preserve_source
}

# terraria listener
resource "oci_network_load_balancer_listener" "terraria" {
  default_backend_set_name = oci_network_load_balancer_backend_set.terraria.name
  name                     = var.terraria_listener_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.terraria_listener_port
  protocol                 = var.terraria_listener_protocol
}

# register worker nodes as terraria backends
resource "oci_network_load_balancer_backend" "terraria" {
  for_each = { for idx, id in var.worker_instance_ids : idx => id }

  backend_set_name         = oci_network_load_balancer_backend_set.terraria.name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.terraria_backend_port
  target_id                = each.value
}
