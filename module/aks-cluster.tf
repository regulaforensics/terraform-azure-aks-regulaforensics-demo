resource "azurerm_resource_group" "app_group" {
  location = var.location
  name     = var.name
}


resource "random_pet" "prefix" {}


module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 10.0"

  resource_group_name = azurerm_resource_group.app_group.name
  location            = var.location

  cluster_name       = var.name
  kubernetes_version = "1.31"
  prefix             = random_pet.prefix.id

  vnet_subnet = {
    id = module.vnet_aks_subnet.resource_id
  }

  sku_tier                        = var.sku_tier
  agents_size                     = var.agents_size
  os_disk_size_gb                 = var.os_disk_size_gb
  agents_count                    = null
  enable_auto_scaling             = true
  agents_min_count                = var.agents_min_count
  agents_max_count                = var.agents_max_count
  agents_pool_name                = "regula"
  agents_availability_zones       = var.agents_availability_zones
  rbac_aad                        = false
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  depends_on = [module.vnet, azurerm_resource_group.app_group]
}
