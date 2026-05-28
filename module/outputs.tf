output "resource_group_name" {
  value = azurerm_resource_group.app_group.name
}

output "config" {
  description = "Cluster kubeconfig (YAML)"
  value       = module.aks.kube_config
  sensitive   = true
}

output "storage_account_name" {
  description = "Azure Blob Storage account name"
  value       = azurerm_storage_account.regula.name
}

output "storage_container_name" {
  description = "Azure Blob Storage container name"
  value       = azurerm_storage_container.regula.name
}

output "workload_identity_client_id" {
  description = "Client ID of the managed identity for workload identity"
  value       = azurerm_user_assigned_identity.regula.client_id
}

output "database_connection_string" {
  description = "Azure SQL connection string for Face API (passwordless auth via workload identity)"
  value       = "mssql+pyodbc://@${azurerm_mssql_server.regula.fully_qualified_domain_name}/${azurerm_mssql_database.regula.name}?driver=ODBC+Driver+18+for+SQL+Server"
}
