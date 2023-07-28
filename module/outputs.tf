output "resource_group_name" {
  value = azurerm_resource_group.app_group.name
}

output "config" {
  description = "Cluster config"
  value       = module.aks.kube_config_raw
  sensitive   = true
}
