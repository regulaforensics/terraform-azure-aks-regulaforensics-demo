module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "4.0.0"
  vnet_location       = azurerm_resource_group.app_group.location
  resource_group_name = azurerm_resource_group.app_group.name
  use_for_each        = true
  vnet_name           = var.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names

  depends_on = [azurerm_resource_group.app_group]
}
