# oracle-talos-prod.tf - workspace and vars

resource "tfe_workspace" "oracle_talos_prod" {
  name              = "oracle-talos-prod"
  organization      = "zemn"
  working_directory = "oracle-talos/envs/prod"
  trigger_prefixes  = ["oracle-talos/"]

  vcs_repo {
    identifier                 = "andrewzn69/terraform"
    branch                     = "master"
    github_app_installation_id = var.github_app_installation_id
  }
}

resource "tfe_workspace_settings" "oracle_talos_prod" {
  workspace_id   = tfe_workspace.oracle_talos_prod.id
  execution_mode = "remote"
}

# --- oci auth ---

resource "tfe_variable" "oci_tenancy_ocid" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "tenancy_ocid"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "oci_user_ocid" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "user_ocid"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "oci_fingerprint" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "fingerprint"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "oci_private_key" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "oci_private_key"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "oci_region" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "region"
  value        = "eu-frankfurt-1"
  category     = "terraform"
}

# --- oci compartment ---

resource "tfe_variable" "oci_compartment_id" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "compartment_id"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "tfe_variable" "oci_namespace" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "namespace"
  value        = ""
  category     = "terraform"
  sensitive    = true

  lifecycle {
    ignore_changes = [value]
  }
}

# --- network ---

resource "tfe_variable" "vcn_cidr_blocks" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "vcn_cidr_blocks"
  value        = "10.0.0.0/16"
  category     = "terraform"
}

resource "tfe_variable" "subnet_cidr_block" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "subnet_cidr_block"
  value        = "10.0.0.0/24"
  category     = "terraform"
}

# --- cluster ---

resource "tfe_variable" "cluster_name" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "cluster_name"
  value        = "novigrad"
  category     = "terraform"
}

# --- instance config ---

resource "tfe_variable" "instance_shape" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "instance_shape"
  value        = "VM.Standard.A1.Flex"
  category     = "terraform"
}

resource "tfe_variable" "instance_launch_options_network_type" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "instance_launch_options_network_type"
  value        = "PARAVIRTUALIZED"
  category     = "terraform"
}

resource "tfe_variable" "boot_volume_size_gb" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "boot_volume_size_gb"
  value        = "20"
  category     = "terraform"
}

# --- controlplane pool ---

resource "tfe_variable" "controlplane_count" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "controlplane_count"
  value        = "1"
  category     = "terraform"
}

resource "tfe_variable" "controlplane_memory_gb" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "controlplane_memory_gb"
  value        = "4"
  category     = "terraform"
}

resource "tfe_variable" "controlplane_ocpus" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "controlplane_ocpus"
  value        = "1"
  category     = "terraform"
}

resource "tfe_variable" "controlplane_base_ip_offset" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "controlplane_base_ip_offset"
  value        = "10"
  category     = "terraform"
}

# --- worker pool ---

resource "tfe_variable" "worker_count" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "worker_count"
  value        = "2"
  category     = "terraform"
}

resource "tfe_variable" "worker_memory_gb" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "worker_memory_gb"
  value        = "10"
  category     = "terraform"
}

resource "tfe_variable" "worker_ocpus" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "worker_ocpus"
  value        = "1.5"
  category     = "terraform"
}

resource "tfe_variable" "worker_base_ip_offset" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "worker_base_ip_offset"
  value        = "20"
  category     = "terraform"
}

resource "tfe_variable" "worker_data_volume_size_gb" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "worker_data_volume_size_gb"
  value        = "55"
  category     = "terraform"
}

# --- ports ---

resource "tfe_variable" "talos_backend_port" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "talos_backend_port"
  value        = "50000"
  category     = "terraform"
}

resource "tfe_variable" "controlplane_backend_port" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "controlplane_backend_port"
  value        = "6443"
  category     = "terraform"
}

# --- free tier limits ---

resource "tfe_variable" "free_tier_memory_limit" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "free_tier_memory_limit"
  value        = "24"
  category     = "terraform"
}

resource "tfe_variable" "free_tier_ocpu_limit" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "free_tier_ocpu_limit"
  value        = "4"
  category     = "terraform"
}

resource "tfe_variable" "free_tier_storage_limit_gb" {
  workspace_id = tfe_workspace.oracle_talos_prod.id
  key          = "free_tier_storage_limit_gb"
  value        = "200"
  category     = "terraform"
}
