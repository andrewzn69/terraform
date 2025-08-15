resource "oci_core_vcn" "talos_vcn" {
  # REQUIRED
  compartment_id = var.compartment_id

  # OPTIONAL
  # byoipv6cidr_details {
  #   #Required
  #   byoipv6range_id = oci_core_byoipv6range.test_byoipv6range.id
  #   ipv6cidr_block  = var.vcn_byoipv6cidr_details_ipv6cidr_block
  # }
  # cidr_block                       = var.vcn_cidr_block
  cidr_blocks = [var.vcn_cidr_blocks]
  # defined_tags                     = { "Operations.CostCenter" = "42" }
  display_name = var.vcn_display_name
  dns_label    = var.vcn_dns_label
  # freeform_tags                    = { "Department" = "Finance" }
  # ipv6private_cidr_blocks          = var.vcn_ipv6private_cidr_blocks
  # is_ipv6enabled                   = var.vcn_is_ipv6enabled
  # is_oracle_gua_allocation_enabled = var.vcn_is_oracle_gua_allocation_enabled
  # security_attributes              = var.vcn_security_attributes
}

resource "oci_core_internet_gateway" "talos_internet_gateway" {
  # REQUIRED
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id

  # OPTIONAL
  enabled = var.internet_gateway_enabled
  # defined_tags   = { "Operations.CostCenter" = "42" }
  display_name = var.internet_gateway_display_name
  # freeform_tags  = { "Department" = "Finance" }
  # route_table_id = oci_core_route_table.test_route_table.id
}

resource "oci_core_route_table" "talos_route_table" {
  # REQUIRED
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id

  # OPTIONAL
  # defined_tags  = { "Operations.CostCenter" = "42" }
  display_name = var.route_table_display_name
  # freeform_tags = { "Department" = "Finance" }
  route_rules {
    # REQUIRED
    network_entity_id = oci_core_internet_gateway.talos_internet_gateway.id

    # OPTIONAL
    # cidr_block       = var.route_table_route_rules_cidr_block
    # description      = var.route_table_route_rules_description
    destination      = var.route_table_route_rules_destination
    destination_type = var.route_table_route_rules_destination_type
  }
}

resource "oci_core_security_list" "talos_security_list" {
  # REQUIRED
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id

  # OPTIONAL
  # defined_tags = { "Operations.CostCenter" = "42" }
  display_name = var.security_list_display_name
  egress_security_rules {
    # REQUIRED
    destination = var.security_list_egress_security_rules_destination
    protocol    = var.security_list_egress_security_rules_protocol

    # OPTIONAL
    # description      = var.security_list_egress_security_rules_description
    destination_type = var.security_list_egress_security_rules_destination_type
    # icmp_options {
    #   # REQUIRED
    #   type = var.security_list_egress_security_rules_icmp_options_type
    #  
    #   # OPTIONAL
    #   code = var.security_list_egress_security_rules_icmp_options_code
    # }
    # stateless = var.security_list_egress_security_rules_stateless
    # tcp_options {
    #  
    #   # OPTIONAL
    #   max = var.security_list_egress_security_rules_tcp_options_destination_port_range_max
    #   min = var.security_list_egress_security_rules_tcp_options_destination_port_range_min
    #   source_port_range {
    #     # REQUIRED
    #     max = var.security_list_egress_security_rules_tcp_options_source_port_range_max
    #     min = var.security_list_egress_security_rules_tcp_options_source_port_range_min
    #   }
    # }
    # udp_options {
    #  
    #   # OPTIONAL
    #   max = var.security_list_egress_security_rules_udp_options_destination_port_range_max
    #   min = var.security_list_egress_security_rules_udp_options_destination_port_range_min
    #   source_port_range {
    #     # REQUIRED
    #     max = var.security_list_egress_security_rules_udp_options_source_port_range_max
    #     min = var.security_list_egress_security_rules_udp_options_source_port_range_min
    #   }
    # }
  }
  # freeform_tags = { "Department" = "Finance" }
  ingress_security_rules {
    # REQUIRED
    protocol = var.security_list_ingress_security_rules_protocol
    source   = var.security_list_ingress_security_rules_source

    # # OPTIONAL
    # description = var.security_list_ingress_security_rules_description
    # icmp_options {
    #   # REQUIRED
    #   type = var.security_list_ingress_security_rules_icmp_options_type
    #
    #   # OPTIONAL
    #   code = var.security_list_ingress_security_rules_icmp_options_code
    # }
    # source_type = var.security_list_ingress_security_rules_source_type
    # stateless   = var.security_list_ingress_security_rules_stateless
    # tcp_options {
    #
    #   # OPTIONAL
    #   max = var.security_list_ingress_security_rules_tcp_options_destination_port_range_max
    #   min = var.security_list_ingress_security_rules_tcp_options_destination_port_range_min
    #   source_port_range {
    #     # REQUIRED
    #     max = var.security_list_ingress_security_rules_tcp_options_source_port_range_max
    #     min = var.security_list_ingress_security_rules_tcp_options_source_port_range_min
    #   }
    # }
    # udp_options {
    #
    #   # OPTIONAL
    #   max = var.security_list_ingress_security_rules_udp_options_destination_port_range_max
    #   min = var.security_list_ingress_security_rules_udp_options_destination_port_range_min
    #   source_port_range {
    #     # REQUIRED
    #     max = var.security_list_ingress_security_rules_udp_options_source_port_range_max
    #     min = var.security_list_ingress_security_rules_udp_options_source_port_range_min
    #   }
    # }
  }
}

resource "oci_core_subnet" "talos_subnet" {
  # REQUIRED
  cidr_block     = var.subnet_cidr_block
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.talos_vcn.id

  # OPTIONAL
  # availability_domain        = var.subnet_availability_domain
  # defined_tags               = { "Operations.CostCenter" = "42" }
  # dhcp_options_id            = oci_core_dhcp_options.test_dhcp_options.id
  display_name = var.subnet_display_name
  # dns_label                  = var.subnet_dns_label
  # freeform_tags              = { "Department" = "Finance" }
  # ipv6cidr_block             = var.subnet_ipv6cidr_block
  # ipv6cidr_blocks            = var.subnet_ipv6cidr_blocks
  # prohibit_internet_ingress  = var.subnet_prohibit_internet_ingress
  # prohibit_public_ip_on_vnic = var.subnet_prohibit_public_ip_on_vnic
  route_table_id    = oci_core_route_table.talos_route_table.id
  security_list_ids = [oci_core_security_list.talos_security_list.id]
}
