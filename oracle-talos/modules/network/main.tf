resource "oci_core_vcn" "talos_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_blocks]
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "talos_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  enabled        = var.internet_gateway_enabled
  display_name   = var.internet_gateway_display_name
}

resource "oci_core_route_table" "talos_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  display_name   = var.route_table_display_name
  route_rules {
    network_entity_id = oci_core_internet_gateway.talos_internet_gateway.id
    destination       = var.route_table_route_rules_destination
    destination_type  = var.route_table_route_rules_destination_type
  }
}

resource "oci_core_security_list" "talos_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  display_name   = var.security_list_display_name
  egress_security_rules {
    destination      = var.security_list_egress_security_rules_destination
    protocol         = var.security_list_egress_security_rules_protocol
    destination_type = var.security_list_egress_security_rules_destination_type
  }
  ingress_security_rules {
    protocol = var.security_list_ingress_security_rules_protocol
    source   = var.security_list_ingress_security_rules_source
  }
}

resource "oci_core_subnet" "talos_subnet" {
  cidr_block        = var.subnet_cidr_block
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.talos_vcn.id
  display_name      = var.subnet_display_name
  route_table_id    = oci_core_route_table.talos_route_table.id
  security_list_ids = [oci_core_security_list.talos_security_list.id]
}

resource "oci_network_load_balancer_network_load_balancer" "controlplane_load_balancer" {
  compartment_id                 = var.compartment_id
  display_name                   = var.network_load_balancer_display_name
  subnet_id                      = oci_core_subnet.talos_subnet.id
  is_preserve_source_destination = var.network_load_balancer_is_preserve_source_destination
  is_private                     = var.network_load_balancer_is_private
}

resource "oci_network_load_balancer_backend_set" "talos_backend_set" {
  health_checker {
    protocol           = var.talos_health_checker_protocol
    interval_in_millis = var.talos_health_checker_interval_in_millis
    port               = var.talos_health_checker_port
  }
  name                     = var.talos_backend_set_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = var.backend_set_policy
  is_preserve_source       = var.talos_backend_set_is_preserve_source
}

resource "oci_network_load_balancer_backend_set" "controlplane_backend_set" {
  health_checker {
    protocol           = var.controlplane_health_checker_protocol
    interval_in_millis = var.controlplane_health_checker_interval_in_millis
    port               = var.controlplane_health_checker_port
    return_code        = var.controlplane_health_checker_return_code
    url_path           = var.controlplane_health_checker_url_path
  }
  name                     = var.controlplane_backend_set_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = var.backend_set_policy
  is_preserve_source       = var.controlplane_backend_set_is_preserve_source
}

resource "oci_network_load_balancer_listener" "talos_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.talos_backend_set.name
  name                     = var.talos_listener_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.talos_listener_port
  protocol                 = var.talos_listener_protocol
}

resource "oci_network_load_balancer_listener" "controlplane_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.controlplane_backend_set.name
  name                     = var.controlplane_listener_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.controlplane_listener_port
  protocol                 = var.controlplane_listener_protocol
}
