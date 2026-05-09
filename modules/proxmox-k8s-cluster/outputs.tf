# outputs.tf

output "control_plane_ips" {
  description = "IP addresses of all control plane VMs"
  value       = [for vm in local.control_plane_vms : vm.ip]
}

output "worker_ips" {
  description = "IP addresses of all worker VMs"
  value       = [for vm in local.worker_vms : vm.ip]
}

output "control_plane_vms" {
  description = "Full config of all control plane VMs"
  value       = local.control_plane_vms
}

output "worker_vms" {
  description = "Full config of all worker VMs"
  value       = local.worker_vms
}
