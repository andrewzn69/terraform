terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.9.0-alpha.0"
    }
  }
}

# talos config files
resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = var.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [var.load_balancer_ip]
}

# vm creation

data "oci_identity_availability_domains" "availability_domains" {
  # REQUIRED
  compartment_id = var.compartment_id
}

resource "oci_core_instance" "controlplane_instance" {
  # REQUIRED
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape

  # OPTIONAL
  # agent_config {
  #
  #     #Optional
  #     are_all_plugins_disabled = var.instance_agent_config_are_all_plugins_disabled
  #     is_management_disabled = var.instance_agent_config_is_management_disabled
  #     is_monitoring_disabled = var.instance_agent_config_is_monitoring_disabled
  #     plugins_config {
  #         # REQUIRED
  #         desired_state = var.instance_agent_config_plugins_config_desired_state
  #         name = var.instance_agent_config_plugins_config_name
  #     }
  # }
  # availability_config {
  #
  #     # OPTIONAL
  #     is_live_migration_preferred = var.instance_availability_config_is_live_migration_preferred
  #     recovery_action = var.instance_availability_config_recovery_action
  # }
  # cluster_placement_group_id = oci_identity_group.test_group.id
  # compute_cluster_id = oci_core_compute_cluster.test_compute_cluster.id
  # compute_host_group_id = oci_core_compute_host_group.test_compute_host_group.id
  create_vnic_details {
    # OPTIONAL
    #     assign_ipv6ip = var.instance_create_vnic_details_assign_ipv6ip
    #     assign_private_dns_record = var.instance_create_vnic_details_assign_private_dns_record
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    #     defined_tags = {"Operations.CostCenter"= "42"}
    #     display_name = var.instance_create_vnic_details_display_name
    #     freeform_tags = {"Department"= "Finance"}
    #     hostname_label = var.instance_create_vnic_details_hostname_label
    #     ipv6address_ipv6subnet_cidr_pair_details = var.instance_create_vnic_details_ipv6address_ipv6subnet_cidr_pair_details
    #     nsg_ids = var.instance_create_vnic_details_nsg_ids
    private_ip = var.controlplane_private_ip
    #     security_attributes = var.instance_create_vnic_details_security_attributes
    #     skip_source_dest_check = var.instance_create_vnic_details_skip_source_dest_check
    subnet_id = var.subnet_id
    #     vlan_id = oci_core_vlan.test_vlan.id
  }
  # dedicated_vm_host_id = oci_core_dedicated_vm_host.test_dedicated_vm_host.id
  # defined_tags = {"Operations.CostCenter"= "42"}
  display_name = var.controlplane_display_name
  # extended_metadata = {
  #     some_string = "stringA"
  #     nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
  # }
  # fault_domain = var.instance_fault_domain
  # freeform_tags = {"Department"= "Finance"}
  # hostname_label = var.instance_hostname_label
  # instance_configuration_id = oci_core_instance_configuration.test_instance_configuration.id
  # instance_options {
  #
  #     # OPTIONAL
  #     are_legacy_imds_endpoints_disabled = var.instance_instance_options_are_legacy_imds_endpoints_disabled
  # }
  # ipxe_script = var.instance_ipxe_script
  # is_pv_encryption_in_transit_enabled = var.instance_is_pv_encryption_in_transit_enabled
  launch_options {
    # OPTIONAL
    #     boot_volume_type = var.instance_launch_options_boot_volume_type
    #     firmware = var.instance_launch_options_firmware
    #     is_consistent_volume_naming_enabled = var.instance_launch_options_is_consistent_volume_naming_enabled
    #     is_pv_encryption_in_transit_enabled = var.instance_launch_options_is_pv_encryption_in_transit_enabled
    network_type = var.instance_launch_options_network_type
    #     remote_data_volume_type = var.instance_launch_options_remote_data_volume_type
  }
  # launch_volume_attachments {
  #     # REQUIRED
  #     type = var.instance_launch_volume_attachments_type
  #
  #     # OPTIONAL
  #     device = var.instance_launch_volume_attachments_device
  #     display_name = var.instance_launch_volume_attachments_display_name
  #     encryption_in_transit_type = var.instance_launch_volume_attachments_encryption_in_transit_type
  #     is_agent_auto_iscsi_login_enabled = var.instance_launch_volume_attachments_is_agent_auto_iscsi_login_enabled
  #     is_pv_encryption_in_transit_enabled = var.instance_launch_volume_attachments_is_pv_encryption_in_transit_enabled
  #     is_read_only = var.instance_launch_volume_attachments_is_read_only
  #     is_shareable = var.instance_launch_volume_attachments_is_shareable
  #     launch_create_volume_details {
  #         # REQUIRED
  #         size_in_gbs = var.instance_launch_volume_attachments_launch_create_volume_details_size_in_gbs
  #         volume_creation_type = var.instance_launch_volume_attachments_launch_create_volume_details_volume_creation_type
  #
  #         # OPTIONAL
  #         compartment_id = var.compartment_id
  #         display_name = var.instance_launch_volume_attachments_launch_create_volume_details_display_name
  #         kms_key_id = oci_kms_key.test_key.id
  #         vpus_per_gb = var.instance_launch_volume_attachments_launch_create_volume_details_vpus_per_gb
  #     }
  #     use_chap = var.instance_launch_volume_attachments_use_chap
  #     volume_id = oci_core_volume.test_volume.id
  # }
  # licensing_configs {
  #     # REQUIRED
  #     type = var.instance_licensing_configs_type
  #
  #     # OPTIONAL
  #     license_type = var.instance_licensing_configs_license_type
  # }
  metadata = { user_data = base64encode(data.talos_machine_configuration.controlplane.machine_configuration) }
  # placement_constraint_details {
  #     # REQURIED
  #     type = var.instance_placement_constraint_details_type
  #
  #     # OPTIONAL
  #     compute_bare_metal_host_id = oci_core_compute_bare_metal_host.test_compute_bare_metal_host.id
  #     compute_host_group_id = oci_identity_group.test_group.id
  # }
  # platform_config {
  #     # REQUIRED
  #     type = var.instance_platform_config_type
  #
  #     # OPTIONAL
  #     are_virtual_instructions_enabled = var.instance_platform_config_are_virtual_instructions_enabled
  #     config_map = var.instance_platform_config_config_map
  #     is_access_control_service_enabled = var.instance_platform_config_is_access_control_service_enabled
  #     is_input_output_memory_management_unit_enabled = var.instance_platform_config_is_input_output_memory_management_unit_enabled
  #     is_measured_boot_enabled = var.instance_platform_config_is_measured_boot_enabled
  #     is_memory_encryption_enabled = var.instance_platform_config_is_memory_encryption_enabled
  #     is_secure_boot_enabled = var.instance_platform_config_is_secure_boot_enabled
  #     is_symmetric_multi_threading_enabled = var.instance_platform_config_is_symmetric_multi_threading_enabled
  #     is_trusted_platform_module_enabled = var.instance_platform_config_is_trusted_platform_module_enabled
  #     numa_nodes_per_socket = var.instance_platform_config_numa_nodes_per_socket
  #     percentage_of_cores_enabled = var.instance_platform_config_percentage_of_cores_enabled
  # }
  # preemptible_instance_config {
  #     # REQUIRED
  #     preemption_action {
  #         # REQUIRED
  #         type = var.instance_preemptible_instance_config_preemption_action_type
  #
  #         # OPTIONAL
  #         preserve_boot_volume = var.instance_preemptible_instance_config_preemption_action_preserve_boot_volume
  #     }
  # }
  # security_attributes = var.instance_security_attributes
  shape_config {
    # OPTIONAL
    #     baseline_ocpu_utilization = var.instance_shape_config_baseline_ocpu_utilization
    memory_in_gbs = var.controlplane_memory_in_gbs
    #     nvmes = var.instance_shape_config_nvmes
    ocpus = var.controlplane_ocpus
    # vcpus = var.controlplane_vcpus
  }
  source_details {
    # REQUIRED
    source_id   = var.custom_image_id
    source_type = "image"
    #
    #     # OPTIONAL
    #     boot_volume_size_in_gbs = var.instance_source_details_boot_volume_size_in_gbs
    #     boot_volume_vpus_per_gb = var.instance_source_details_boot_volume_vpus_per_gb
    #     instance_source_image_filter_details {
    #         # REQUIRED
    #         compartment_id = var.compartment_id
    #
    #         # OPTIONAL
    #         defined_tags_filter = var.instance_source_details_instance_source_image_filter_details_defined_tags_filter
    #         operating_system = var.instance_source_details_instance_source_image_filter_details_operating_system
    #         operating_system_version = var.instance_source_details_instance_source_image_filter_details_operating_system_version
    #     }
    #     kms_key_id = oci_kms_key.test_key.id
  }
  # preserve_boot_volume = false
}

resource "oci_core_instance" "worker_instance" {
  # REQUIRED
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape

  # OPTIONAL
  # agent_config {
  #
  #     #Optional
  #     are_all_plugins_disabled = var.instance_agent_config_are_all_plugins_disabled
  #     is_management_disabled = var.instance_agent_config_is_management_disabled
  #     is_monitoring_disabled = var.instance_agent_config_is_monitoring_disabled
  #     plugins_config {
  #         # REQUIRED
  #         desired_state = var.instance_agent_config_plugins_config_desired_state
  #         name = var.instance_agent_config_plugins_config_name
  #     }
  # }
  # availability_config {
  #
  #     # OPTIONAL
  #     is_live_migration_preferred = var.instance_availability_config_is_live_migration_preferred
  #     recovery_action = var.instance_availability_config_recovery_action
  # }
  # cluster_placement_group_id = oci_identity_group.test_group.id
  # compute_cluster_id = oci_core_compute_cluster.test_compute_cluster.id
  # compute_host_group_id = oci_core_compute_host_group.test_compute_host_group.id
  create_vnic_details {
    # OPTIONAL
    #     assign_ipv6ip = var.instance_create_vnic_details_assign_ipv6ip
    #     assign_private_dns_record = var.instance_create_vnic_details_assign_private_dns_record
    assign_public_ip = var.instance_create_vnic_details_assign_public_ip
    #     defined_tags = {"Operations.CostCenter"= "42"}
    #     display_name = var.instance_create_vnic_details_display_name
    #     freeform_tags = {"Department"= "Finance"}
    #     hostname_label = var.instance_create_vnic_details_hostname_label
    #     ipv6address_ipv6subnet_cidr_pair_details = var.instance_create_vnic_details_ipv6address_ipv6subnet_cidr_pair_details
    #     nsg_ids = var.instance_create_vnic_details_nsg_ids
    private_ip = var.worker_private_ip
    #     security_attributes = var.instance_create_vnic_details_security_attributes
    #     skip_source_dest_check = var.instance_create_vnic_details_skip_source_dest_check
    subnet_id = var.subnet_id
    #     vlan_id = oci_core_vlan.test_vlan.id
  }
  # dedicated_vm_host_id = oci_core_dedicated_vm_host.test_dedicated_vm_host.id
  # defined_tags = {"Operations.CostCenter"= "42"}
  display_name = var.worker_display_name
  # extended_metadata = {
  #     some_string = "stringA"
  #     nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
  # }
  # fault_domain = var.instance_fault_domain
  # freeform_tags = {"Department"= "Finance"}
  # hostname_label = var.instance_hostname_label
  # instance_configuration_id = oci_core_instance_configuration.test_instance_configuration.id
  # instance_options {
  #
  #     # OPTIONAL
  #     are_legacy_imds_endpoints_disabled = var.instance_instance_options_are_legacy_imds_endpoints_disabled
  # }
  # ipxe_script = var.instance_ipxe_script
  # is_pv_encryption_in_transit_enabled = var.instance_is_pv_encryption_in_transit_enabled
  launch_options {
    # OPTIONAL
    #     boot_volume_type = var.instance_launch_options_boot_volume_type
    #     firmware = var.instance_launch_options_firmware
    #     is_consistent_volume_naming_enabled = var.instance_launch_options_is_consistent_volume_naming_enabled
    #     is_pv_encryption_in_transit_enabled = var.instance_launch_options_is_pv_encryption_in_transit_enabled
    network_type = var.instance_launch_options_network_type
    #     remote_data_volume_type = var.instance_launch_options_remote_data_volume_type
  }
  # launch_volume_attachments {
  #     # REQUIRED
  #     type = var.instance_launch_volume_attachments_type
  #
  #     # OPTIONAL
  #     device = var.instance_launch_volume_attachments_device
  #     display_name = var.instance_launch_volume_attachments_display_name
  #     encryption_in_transit_type = var.instance_launch_volume_attachments_encryption_in_transit_type
  #     is_agent_auto_iscsi_login_enabled = var.instance_launch_volume_attachments_is_agent_auto_iscsi_login_enabled
  #     is_pv_encryption_in_transit_enabled = var.instance_launch_volume_attachments_is_pv_encryption_in_transit_enabled
  #     is_read_only = var.instance_launch_volume_attachments_is_read_only
  #     is_shareable = var.instance_launch_volume_attachments_is_shareable
  #     launch_create_volume_details {
  #         # REQUIRED
  #         size_in_gbs = var.instance_launch_volume_attachments_launch_create_volume_details_size_in_gbs
  #         volume_creation_type = var.instance_launch_volume_attachments_launch_create_volume_details_volume_creation_type
  #
  #         # OPTIONAL
  #         compartment_id = var.compartment_id
  #         display_name = var.instance_launch_volume_attachments_launch_create_volume_details_display_name
  #         kms_key_id = oci_kms_key.test_key.id
  #         vpus_per_gb = var.instance_launch_volume_attachments_launch_create_volume_details_vpus_per_gb
  #     }
  #     use_chap = var.instance_launch_volume_attachments_use_chap
  #     volume_id = oci_core_volume.test_volume.id
  # }
  # licensing_configs {
  #     # REQUIRED
  #     type = var.instance_licensing_configs_type
  #
  #     # OPTIONAL
  #     license_type = var.instance_licensing_configs_license_type
  # }
  metadata = { user_data = base64encode(data.talos_machine_configuration.worker.machine_configuration) }
  # placement_constraint_details {
  #     # REQURIED
  #     type = var.instance_placement_constraint_details_type
  #
  #     # OPTIONAL
  #     compute_bare_metal_host_id = oci_core_compute_bare_metal_host.test_compute_bare_metal_host.id
  #     compute_host_group_id = oci_identity_group.test_group.id
  # }
  # platform_config {
  #     # REQUIRED
  #     type = var.instance_platform_config_type
  #
  #     # OPTIONAL
  #     are_virtual_instructions_enabled = var.instance_platform_config_are_virtual_instructions_enabled
  #     config_map = var.instance_platform_config_config_map
  #     is_access_control_service_enabled = var.instance_platform_config_is_access_control_service_enabled
  #     is_input_output_memory_management_unit_enabled = var.instance_platform_config_is_input_output_memory_management_unit_enabled
  #     is_measured_boot_enabled = var.instance_platform_config_is_measured_boot_enabled
  #     is_memory_encryption_enabled = var.instance_platform_config_is_memory_encryption_enabled
  #     is_secure_boot_enabled = var.instance_platform_config_is_secure_boot_enabled
  #     is_symmetric_multi_threading_enabled = var.instance_platform_config_is_symmetric_multi_threading_enabled
  #     is_trusted_platform_module_enabled = var.instance_platform_config_is_trusted_platform_module_enabled
  #     numa_nodes_per_socket = var.instance_platform_config_numa_nodes_per_socket
  #     percentage_of_cores_enabled = var.instance_platform_config_percentage_of_cores_enabled
  # }
  # preemptible_instance_config {
  #     # REQUIRED
  #     preemption_action {
  #         # REQUIRED
  #         type = var.instance_preemptible_instance_config_preemption_action_type
  #
  #         # OPTIONAL
  #         preserve_boot_volume = var.instance_preemptible_instance_config_preemption_action_preserve_boot_volume
  #     }
  # }
  # security_attributes = var.instance_security_attributes
  shape_config {
    # OPTIONAL
    #     baseline_ocpu_utilization = var.instance_shape_config_baseline_ocpu_utilization
    memory_in_gbs = var.worker_memory_in_gbs
    #     nvmes = var.instance_shape_config_nvmes
    ocpus = var.worker_ocpus
    # vcpus = var.worker_vcpus
  }
  source_details {
    # REQUIRED
    source_id   = var.custom_image_id
    source_type = "image"
    #
    #     # OPTIONAL
    #     boot_volume_size_in_gbs = var.instance_source_details_boot_volume_size_in_gbs
    #     boot_volume_vpus_per_gb = var.instance_source_details_boot_volume_vpus_per_gb
    #     instance_source_image_filter_details {
    #         # REQUIRED
    #         compartment_id = var.compartment_id
    #
    #         # OPTIONAL
    #         defined_tags_filter = var.instance_source_details_instance_source_image_filter_details_defined_tags_filter
    #         operating_system = var.instance_source_details_instance_source_image_filter_details_operating_system
    #         operating_system_version = var.instance_source_details_instance_source_image_filter_details_operating_system_version
    #     }
    #     kms_key_id = oci_kms_key.test_key.id
  }
  # preserve_boot_volume = false
}

resource "oci_network_load_balancer_backend" "controlplane_talos_backend" {
  # REQUIRED
  backend_set_name         = var.talos_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.talos_backend_port

  # OPTIONAL
  # ip_address = var.backend_ip_address
  # is_backup = var.backend_is_backup
  # is_drain = var.backend_is_drain
  # is_offline = var.backend_is_offline
  # name = var.backend_name
  target_id = oci_core_instance.controlplane_instance.id
  # weight = var.backend_weight
}

resource "oci_network_load_balancer_backend" "controlplane_controlplane_backend" {
  # REQUIRED
  backend_set_name         = var.controlplane_backend_set_name
  network_load_balancer_id = var.network_load_balancer_id
  port                     = var.controlplane_backend_port

  # OPTIONAL
  # ip_address = var.backend_ip_address
  # is_backup = var.backend_is_backup
  # is_drain = var.backend_is_drain
  # is_offline = var.backend_is_offline
  # name = var.backend_name
  target_id = oci_core_instance.controlplane_instance.id
  # weight = var.backend_weight
}
