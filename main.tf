module "aks_cluster" {
  source                          = "github.com/regulaforensics/terraform-azure-regulaforensics-demo"
  subscription_id                 = var.subscription_id
  name                            = var.name
  address_space                   = var.address_space
  address_prefix                  = var.address_prefix
  aks_subnet_name                 = var.aks_subnet_name
  location                        = var.location
  sku_tier                        = var.sku_tier
  agents_size                     = var.agents_size
  os_disk_size_gb                 = var.os_disk_size_gb
  agents_min_count                = var.agents_min_count
  agents_max_count                = var.agents_max_count
  agents_availability_zones       = var.agents_availability_zones
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
}
