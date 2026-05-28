data "azurerm_client_config" "current" {}

resource "azurerm_mssql_server" "regula" {
  name                = "${var.name}-sql"
  resource_group_name = azurerm_resource_group.app_group.name
  location            = azurerm_resource_group.app_group.location
  version             = "12.0"

  azuread_administrator {
    login_username              = azurerm_user_assigned_identity.regula.name
    object_id                   = azurerm_user_assigned_identity.regula.principal_id
    azuread_authentication_only = true
  }

  minimum_tls_version = "1.2"

  depends_on = [azurerm_resource_group.app_group]
}

resource "azurerm_mssql_database" "regula" {
  name      = "regula"
  server_id = azurerm_mssql_server.regula.id

  # Serverless tier — auto-pause after 60 min, pay per vCore-second
  sku_name                    = "GP_S_Gen5_1"
  min_capacity                = 0.5
  auto_pause_delay_in_minutes = 60
  max_size_gb                 = 32
  zone_redundant              = false
}

# Allow Azure services (AKS workload identity) to reach the SQL server
resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.regula.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
