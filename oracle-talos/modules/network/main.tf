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

resource "oci_network_load_balancer_network_load_balancer" "controlplane_load_balancer" {
  # REQUIRED
  compartment_id = var.compartment_id
  display_name   = var.network_load_balancer_display_name
  subnet_id      = oci_core_subnet.talos_subnet.id

  # OPTIONAL
  # assigned_ipv6 = var.network_load_balancer_assigned_ipv6
  # assigned_private_ipv4 = var.network_load_balancer_assigned_private_ipv4
  # backend_sets {
  #     # REQUIRED
  #     health_checker {
  #         # OPTIONAL
  #         protocol = var.network_load_balancer_backend_sets_health_checker_protocol
  #
  #         # OPTIONAL
  #         interval_in_millis = var.network_load_balancer_backend_sets_health_checker_interval_in_millis
  #         port = var.network_load_balancer_backend_sets_health_checker_port
  #         request_data = var.network_load_balancer_backend_sets_health_checker_request_data
  #         response_body_regex = var.network_load_balancer_backend_sets_health_checker_response_body_regex
  #         response_data = var.network_load_balancer_backend_sets_health_checker_response_data
  #         retries = var.network_load_balancer_backend_sets_health_checker_retries
  #         return_code = var.network_load_balancer_backend_sets_health_checker_return_code
  #         timeout_in_millis = var.network_load_balancer_backend_sets_health_checker_timeout_in_millis
  #         url_path = var.network_load_balancer_backend_sets_health_checker_url_path
  #     }
  #
  #     # OPTIONAL
  #     backends {
  #         # REQUIRED
  #         port = var.network_load_balancer_backend_sets_backends_port
  #
  #         # OPTIONAL
  #         ip_address = var.network_load_balancer_backend_sets_backends_ip_address
  #         is_backup = var.network_load_balancer_backend_sets_backends_is_backup
  #         is_drain = var.network_load_balancer_backend_sets_backends_is_drain
  #         is_offline = var.network_load_balancer_backend_sets_backends_is_offline
  #         name = var.network_load_balancer_backend_sets_backends_name
  #         target_id = oci_cloud_guard_target.test_target.id
  #         weight = var.network_load_balancer_backend_sets_backends_weight
  #     }
  #     ip_version = var.network_load_balancer_backend_sets_ip_version
  #     is_fail_open = var.network_load_balancer_backend_sets_is_fail_open
  #     is_instant_failover_enabled = var.network_load_balancer_backend_sets_is_instant_failover_enabled
  #     policy = var.network_load_balancer_backend_sets_policy
  # }
  #
  # # OPTIONAL
  # backend_sets {
  #     # REQUIRED
  #     health_checker {
  #         # REQUIRED
  #         protocol = var.network_load_balancer_backend_sets_health_checker_protocol
  #
  #         # OPTIONAL
  #         dns {
  #             # REQUIRED
  #             domain_name = oci_identity_domain.test_domain.name
  #
  #             # OPTIONAL
  #             query_class = var.network_load_balancer_backend_sets_health_checker_dns_query_class
  #             query_type = var.network_load_balancer_backend_sets_health_checker_dns_query_type
  #             rcodes = var.network_load_balancer_backend_sets_health_checker_dns_rcodes
  #             transport_protocol = var.network_load_balancer_backend_sets_health_checker_dns_transport_protocol
  #         }
  #         interval_in_millis = var.network_load_balancer_backend_sets_health_checker_interval_in_millis
  #         port = var.network_load_balancer_backend_sets_health_checker_port
  #         request_data = var.network_load_balancer_backend_sets_health_checker_request_data
  #         response_body_regex = var.network_load_balancer_backend_sets_health_checker_response_body_regex
  #         response_data = var.network_load_balancer_backend_sets_health_checker_response_data
  #         retries = var.network_load_balancer_backend_sets_health_checker_retries
  #         return_code = var.network_load_balancer_backend_sets_health_checker_return_code
  #         timeout_in_millis = var.network_load_balancer_backend_sets_health_checker_timeout_in_millis
  #         url_path = var.network_load_balancer_backend_sets_health_checker_url_path
  #     }
  #
  #     # OPTIONAL
  #     are_operationally_active_backends_preferred = var.network_load_balancer_backend_sets_are_operationally_active_backends_preferred
  #     backends {
  #         # REQUIRED
  #         port = var.network_load_balancer_backend_sets_backends_port
  #
  #         # OPTIONAL
  #         ip_address = var.network_load_balancer_backend_sets_backends_ip_address
  #         is_backup = var.network_load_balancer_backend_sets_backends_is_backup
  #         is_drain = var.network_load_balancer_backend_sets_backends_is_drain
  #         is_offline = var.network_load_balancer_backend_sets_backends_is_offline
  #         name = var.network_load_balancer_backend_sets_backends_name
  #         target_id = oci_cloud_guard_target.test_target.id
  #         weight = var.network_load_balancer_backend_sets_backends_weight
  #     }
  #     ip_version = var.network_load_balancer_backend_sets_ip_version
  #     is_fail_open = var.network_load_balancer_backend_sets_is_fail_open
  #     is_instant_failover_enabled = var.network_load_balancer_backend_sets_is_instant_failover_enabled
  #     is_instant_failover_tcp_reset_enabled = var.network_load_balancer_backend_sets_is_instant_failover_tcp_reset_enabled
  #     is_preserve_source = var.network_load_balancer_backend_sets_is_preserve_source
  #     policy = var.network_load_balancer_backend_sets_policy
  # }
  # # OPTIONAl
  # assigned_ipv6 = var.network_load_balancer_assigned_ipv6
  # assigned_private_ipv4 = var.network_load_balancer_assigned_private_ipv4
  # defined_tags = {"Operations.CostCenter"= "42"}
  # freeform_tags = {"Department"= "Finance"}
  is_preserve_source_destination = var.network_load_balancer_is_preserve_source_destination
  is_private                     = var.network_load_balancer_is_private
  # is_symmetric_hash_enabled = var.network_load_balancer_is_symmetric_hash_enabled
  # listeners {
  #     # REQUIRED
  #     default_backend_set_name = oci_network_load_balancer_backend_set.test_backend_set.name
  #     name = var.network_load_balancer_listeners_name
  #     port = var.network_load_balancer_listeners_port
  #     protocol = var.network_load_balancer_listeners_protocol
  #
  #     # OPTIONAL
  #     ip_version = var.network_load_balancer_listeners_ip_version
  #     is_ppv2enabled = var.network_load_balancer_listeners_is_ppv2enabled
  #     l3ip_idle_timeout = var.network_load_balancer_listeners_l3ip_idle_timeout
  #     tcp_idle_timeout = var.network_load_balancer_listeners_tcp_idle_timeout
  #     udp_idle_timeout = var.network_load_balancer_listeners_udp_idle_timeout
  # }
  # network_security_group_ids = var.network_load_balancer_network_security_group_ids
  # nlb_ip_version = var.network_load_balancer_nlb_ip_version
  # reserved_ips {
  #     # OPTIONAL
  #     id = var.network_load_balancer_reserved_ips_id
  # }
  # security_attributes = var.network_load_balancer_security_attributes
  # subnet_ipv6cidr = var.network_load_balancer_subnet_ipv6cidr
}

resource "oci_network_load_balancer_backend_set" "talos_backend_set" {
  # REQUIRED
  health_checker {
    # REQUIRED
    protocol = var.talos_health_checker_protocol

    # OPTIONAL
    # dns {
    #     # REQUIRED
    #     domain_name = oci_identity_domain.test_domain.name
    #
    #     # OPTIONAL
    #     query_class = var.backend_set_health_checker_dns_query_class
    #     query_type = var.backend_set_health_checker_dns_query_type
    #     rcodes = var.backend_set_health_checker_dns_rcodes
    #     transport_protocol = var.backend_set_health_checker_dns_transport_protocol
    # }
    interval_in_millis = var.talos_health_checker_interval_in_millis
    port               = var.talos_health_checker_port
    # request_data = var.backend_set_health_checker_request_data
    # response_body_regex = var.backend_set_health_checker_response_body_regex
    # response_data = var.backend_set_health_checker_response_data
    # retries = var.backend_set_health_checker_retries
    # return_code = var.backend_set_health_checker_return_code
    # timeout_in_millis = var.backend_set_health_checker_timeout_in_millis
    # url_path = var.backend_set_health_checker_url_path
  }
  name                     = var.talos_backend_set_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = var.backend_set_policy

  # OPTIONAL
  # are_operationally_active_backends_preferred = var.backend_set_are_operationally_active_backends_preferred
  # ip_version = var.backend_set_ip_version
  # is_fail_open = var.backend_set_is_fail_open
  # is_instant_failover_enabled = var.backend_set_is_instant_failover_enabled
  # is_instant_failover_tcp_reset_enabled = var.backend_set_is_instant_failover_tcp_reset_enabled
  is_preserve_source = var.talos_backend_set_is_preserve_source
}

resource "oci_network_load_balancer_backend_set" "controlplane_backend_set" {
  # REQUIRED
  health_checker {
    # REQUIRED
    protocol = var.controlplane_health_checker_protocol

    # OPTIONAL
    # dns {
    #     # REQUIRED
    #     domain_name = oci_identity_domain.test_domain.name
    #
    #     # OPTIONAL
    #     query_class = var.backend_set_health_checker_dns_query_class
    #     query_type = var.backend_set_health_checker_dns_query_type
    #     rcodes = var.backend_set_health_checker_dns_rcodes
    #     transport_protocol = var.backend_set_health_checker_dns_transport_protocol
    # }
    interval_in_millis = var.controlplane_health_checker_interval_in_millis
    port               = var.controlplane_health_checker_port
    # request_data = var.backend_set_health_checker_request_data
    # response_body_regex = var.backend_set_health_checker_response_body_regex
    # response_data = var.backend_set_health_checker_response_data
    # retries = var.backend_set_health_checker_retries
    return_code = var.controlplane_health_checker_return_code
    # timeout_in_millis = var.backend_set_health_checker_timeout_in_millis
    url_path = var.controlplane_health_checker_url_path
  }
  name                     = var.controlplane_backend_set_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  policy                   = var.backend_set_policy

  # OPTIONAL
  # are_operationally_active_backends_preferred = var.backend_set_are_operationally_active_backends_preferred
  # ip_version = var.backend_set_ip_version
  # is_fail_open = var.backend_set_is_fail_open
  # is_instant_failover_enabled = var.backend_set_is_instant_failover_enabled
  # is_instant_failover_tcp_reset_enabled = var.backend_set_is_instant_failover_tcp_reset_enabled
  is_preserve_source = var.controlplane_backend_set_is_preserve_source
}

resource "oci_network_load_balancer_listener" "talos_listener" {
  # REQUIRED
  default_backend_set_name = oci_network_load_balancer_backend_set.talos_backend_set.name
  name                     = var.talos_listener_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.talos_listener_port
  protocol                 = var.talos_listener_protocol

  # OPTIONAL
  # ip_version = var.listener_ip_version
  # is_ppv2enabled = var.listener_is_ppv2enabled
  # l3ip_idle_timeout = var.listener_l3ip_idle_timeout
  # tcp_idle_timeout = var.listener_tcp_idle_timeout
  # udp_idle_timeout = var.listener_udp_idle_timeout
}

resource "oci_network_load_balancer_listener" "controlplane_listener" {
  # REQUIRED
  default_backend_set_name = oci_network_load_balancer_backend_set.controlplane_backend_set.name
  name                     = var.controlplane_listener_name
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.controlplane_load_balancer.id
  port                     = var.controlplane_listener_port
  protocol                 = var.controlplane_listener_protocol

  # OPTIONAL
  # ip_version = var.listener_ip_version
  # is_ppv2enabled = var.listener_is_ppv2enabled
  # l3ip_idle_timeout = var.listener_l3ip_idle_timeout
  # tcp_idle_timeout = var.listener_tcp_idle_timeout
  # udp_idle_timeout = var.listener_udp_idle_timeout
}
