resource "oci_core_vcn" "talos_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_blocks]
  display_name   = "${var.cluster_name}-vcn"
  dns_label      = "${var.cluster_name}vcn"
}

resource "oci_core_internet_gateway" "talos_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  enabled        = true
  display_name   = "${var.cluster_name}-igw"
}

resource "oci_core_route_table" "talos_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  display_name   = "${var.cluster_name}-route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.talos_internet_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "talos_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id
  display_name   = "${var.cluster_name}-security-list"

  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
    destination_type = "CIDR_BLOCK"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = var.talos_listener_port
      max = var.talos_listener_port
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = var.controlplane_listener_port
      max = var.controlplane_listener_port
    }
  }

  ingress_security_rules {
    protocol = "all"
    source   = var.vcn_cidr_blocks
  }

  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "talos_subnet" {
  cidr_block        = var.subnet_cidr_block
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.talos_vcn.id
  display_name      = "${var.cluster_name}-subnet"
  dns_label         = "${var.cluster_name}subnet"
  route_table_id    = oci_core_route_table.talos_route_table.id
  security_list_ids = [oci_core_security_list.talos_security_list.id]
}

resource "oci_network_load_balancer_network_load_balancer" "controlplane_load_balancer" {
  compartment_id                 = var.compartment_id
  display_name                   = "${var.cluster_name}-lb"
  subnet_id                      = oci_core_subnet.talos_subnet.id
  is_preserve_source_destination = false
  is_private                     = false
}

resource "oci_network_load_balancer_backend_set" "talos_backend_set" {
  health_checker {
    protocol           = "TCP"
    interval_in_millis = 10000
    port               = var.talos_listener_port
  }
  name                     = "${var.cluster_name}-talos"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = "TWO_TUPLE"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_backend_set" "controlplane_backend_set" {
  health_checker {
    protocol           = "HTTPS"
    interval_in_millis = 10000
    port               = var.controlplane_listener_port
    return_code        = 401
    url_path           = "/readyz"
  }
  name                     = "controlplane"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = "TWO_TUPLE"
  is_preserve_source       = false
}

resource "oci_network_load_balancer_listener" "talos_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.talos_backend_set.name
  name                     = "${var.cluster_name}-talos"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.talos_listener_port
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_listener" "controlplane_listener" {
  default_backend_set_name = oci_network_load_balancer_backend_set.controlplane_backend_set.name
  name                     = "controlplane"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.controlplane_listener_port
  protocol                 = "TCP"
}
