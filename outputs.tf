output "cluster_name" {
  description = "AKS cluster name"
  value       = module.aks_cluster.resource_group_name
}

output "config" {
  description = "Cluster kubeconfig (YAML)"
  value       = module.aks_cluster.config
  sensitive   = true
}

output "storage_account_name" {
  description = "Azure Blob Storage account name for Regula products"
  value       = module.aks_cluster.storage_account_name
}

output "storage_container_name" {
  description = "Azure Blob Storage container name"
  value       = module.aks_cluster.storage_container_name
}

output "workload_identity_client_id" {
  description = "Client ID for workload identity (use in Helm --set)"
  value       = module.aks_cluster.workload_identity_client_id
}

output "database_connection_string" {
  description = "Azure SQL connection string for Face API (passwordless auth)"
  value       = module.aks_cluster.database_connection_string
}
