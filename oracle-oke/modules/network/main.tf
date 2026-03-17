# main.tf - creates vcn, subnets, internet gateway, routing, and security lists

resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  display_name   = "${var.cluster_name}-vcn"
  cidr_blocks    = [var.vcn_cidr_block]
  dns_label      = var.cluster_name

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }
}

resource "oci_core_internet_gateway" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.cluster_name}-igw"
  enabled        = true
}

resource "oci_core_route_table" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.cluster_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main.id
  }
}

resource "oci_core_security_list" "endpoint" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.cluster_name}-endpoint-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # kubernetes api server
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6"
    stateless = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # all infra-cluster traffic
  ingress_security_rules {
    source    = var.vcn_cidr_block
    protocol  = "all"
    stateless = false
  }

  # teamspeak voice traffic (UDP)
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "17"
    stateless = false
    udp_options {
      min = 9987
      max = 9987
    }
  }

  # teamspeak file transfer (TCP)
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6"
    stateless = false
    tcp_options {
      min = 30033
      max = 30033
    }
  }
}

resource "oci_core_security_list" "nodes" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.cluster_name}-nodes-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # all infra-cluster traffic
  ingress_security_rules {
    source    = var.vcn_cidr_block
    protocol  = "all"
    stateless = false
  }

  # teamspeak voice traffic (UDP)
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "17"
    stateless = false
    udp_options {
      min = 9987
      max = 9987
    }
  }

  # teamspeak file transfer (TCP)
  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6"
    stateless = false
    tcp_options {
      min = 30033
      max = 30033
    }
  }
}

resource "oci_core_subnet" "endpoint" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main.id
  display_name      = "${var.cluster_name}-endpoint-subnet"
  cidr_block        = var.endpoint_subnet_cidr_block
  route_table_id    = oci_core_route_table.main.id
  security_list_ids = [oci_core_security_list.endpoint.id]
  dns_label         = "endpoint"

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }
}

resource "oci_core_subnet" "nodes" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main.id
  display_name      = "${var.cluster_name}-nodes-subnet"
  cidr_block        = var.nodes_subnet_cidr_block
  route_table_id    = oci_core_route_table.main.id
  security_list_ids = [oci_core_security_list.nodes.id]
  dns_label         = "nodes"

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }
}
