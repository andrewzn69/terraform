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

resource "oci_core_security_list" "main" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.cluster_name}-sl"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  ingress_security_rules {
    source    = "0.0.0.0/0"
    protocol  = "6"
    stateless = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    source    = var.vcn_cidr_block
    protocol  = "all"
    stateless = false
  }
}

resource "oci_core_subnet" "endpoint" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.main.id
  display_name      = "${var.cluster_name}-endpoint-subnet"
  cidr_block        = var.endpoint_subnet_cidr_block
  route_table_id    = oci_core_route_table.main.id
  security_list_ids = [oci_core_security_list.main.id]
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
  security_list_ids = [oci_core_security_list.main.id]
  dns_label         = "nodes"

  freeform_tags = {
    environment = "prod"
    managed-by  = "terraform"
    cluster     = var.cluster_name
  }
}
