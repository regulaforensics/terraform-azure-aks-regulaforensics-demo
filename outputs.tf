output "cluster_name" {
  description = "AKS cluster name"
  value       = module.aks_cluster.resource_group_name
}

output "config" {
  description = "Cluster kubeconfig (YAML)"
  value       = module.aks_cluster.config
  sensitive   = true
}
