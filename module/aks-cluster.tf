resource "azurerm_resource_group" "app_group" {
  location = var.location
  name     = var.name
}

module "aks" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "~> 0.5"

  name      = var.name
  location  = var.location
  parent_id = azurerm_resource_group.app_group.id

  kubernetes_version = "1.34"

  default_agent_pool = {
    name                = "regula"
    vm_size             = var.agents_size
    os_disk_size_gb     = var.os_disk_size_gb
    enable_auto_scaling = true
    min_count           = var.agents_min_count
    max_count           = var.agents_max_count
    availability_zones  = var.agents_availability_zones
    vnet_subnet_id      = module.vnet_aks_subnet.resource_id
  }

  sku = {
    name = "Base"
    tier = var.sku_tier
  }

  api_server_access_profile = {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  managed_identities = {
    system_assigned = true
  }

  oidc_issuer_profile = {
    enabled = true
  }

  security_profile = {
    workload_identity = {
      enabled = true
    }
  }

  ingress_profile = {
    web_app_routing = {
      enabled = true
    }
  }

  enable_telemetry = false

  depends_on = [module.vnet, azurerm_resource_group.app_group]
}
