output "cluster_name" {
  description = "Cluster name"
  value       = module.aks_cluster.resource_group_name
}

output "config" {
  description = "Cluster config"
  value       = module.aks_cluster.config
  sensitive   = true
}
