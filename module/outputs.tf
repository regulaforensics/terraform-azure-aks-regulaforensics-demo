output "resource_group_name" {
  value = azurerm_resource_group.app_group.name
}

output "config" {
  description = "Cluster kubeconfig (YAML)"
  value       = module.aks.kube_config
  sensitive   = true
}
