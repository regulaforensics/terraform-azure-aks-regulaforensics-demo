resource "azurerm_resource_group" "app_group" {
  location = var.location
  name     = var.name

}


resource "random_pet" "prefix" {}


module "aks" {
  source               = "Azure/aks/azurerm"
  version              = "6.8.0"
  resource_group_name  = azurerm_resource_group.app_group.name
  kubernetes_version   = "1.25.6"
  orchestrator_version = "1.25.6"
  prefix               = var.prefix
  cluster_name         = var.name
  vnet_subnet_id       = module.vnet.vnet_subnets[0]
  network_plugin       = var.network_plugin
  os_disk_size_gb      = var.os_disk_size_gb

  sku_tier                        = var.sku_tier
  agents_count                    = var.agents_count
  agents_max_pods                 = var.agents_max_pods
  agents_pool_name                = "agentpool"
  agents_availability_zones       = var.agents_availability_zones
  agents_type                     = var.agents_type
  agents_size                     = var.agents_size
  rbac_aad                        = false
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  net_profile_docker_bridge_cidr = var.net_profile_docker_bridge_cidr
  net_profile_service_cidr       = var.net_profile_service_cidr
  net_profile_dns_service_ip     = var.net_profile_dns_service_ip

  depends_on = [module.vnet, azurerm_resource_group.app_group]
}
