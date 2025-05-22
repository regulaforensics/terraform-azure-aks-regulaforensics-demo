module "vnet" {
  source              = "Azure/avm-res-network-virtualnetwork/azurerm"
  version             = "v0.8.1"
  address_space       = var.address_space
  location            = azurerm_resource_group.app_group.location
  name                = var.name
  resource_group_name = azurerm_resource_group.app_group.name

  depends_on = [azurerm_resource_group.app_group]
}

module "vnet_aks_subnet" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"

  virtual_network = {
    resource_id = module.vnet.resource_id
  }
  name           = var.aks_subnet_name
  address_prefix = var.address_prefix
}
