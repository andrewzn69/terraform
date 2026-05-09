output "control_plane_ips" {
  description = "IP addresses of all control plane VMs"
  value       = module.k8s_cluster.control_plane_ips
}

output "worker_ips" {
  description = "IP addresses of all worker VMs"
  value       = module.k8s_cluster.worker_ips
}

output "control_plane_vms" {
  description = "Full config of all control plane VMs"
  value       = module.k8s_cluster.control_plane_vms
}

output "worker_vms" {
  description = "Full config of all worker VMs"
  value       = module.k8s_cluster.worker_vms
}
