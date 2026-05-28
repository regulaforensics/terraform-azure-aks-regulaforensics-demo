# nosemgrep: terraform.azure.security.storage.storage-queue-services-logging
resource "azurerm_storage_account" "regula" {
  name                     = replace("${var.name}stor", "-", "")
  resource_group_name      = azurerm_resource_group.app_group.name
  location                 = azurerm_resource_group.app_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  depends_on = [azurerm_resource_group.app_group]
}

resource "azurerm_storage_container" "regula" {
  name                  = "regula"
  storage_account_id    = azurerm_storage_account.regula.id
  container_access_type = "private"
}

# --- Workload Identity for Regula products ---

resource "azurerm_user_assigned_identity" "regula" {
  name                = "${var.name}-regula-wi"
  resource_group_name = azurerm_resource_group.app_group.name
  location            = azurerm_resource_group.app_group.location
}

resource "azurerm_role_assignment" "regula_blob" {
  scope                = azurerm_storage_account.regula.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.regula.principal_id
}

# Federated credential for docreader namespace
resource "azurerm_federated_identity_credential" "docreader" {
  name                      = "docreader"
  user_assigned_identity_id = azurerm_user_assigned_identity.regula.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = module.aks.oidc_issuer_profile_issuer_url
  subject                   = "system:serviceaccount:docreader:docreader-sa"
}

# Federated credential for faceapi namespace
resource "azurerm_federated_identity_credential" "faceapi" {
  name                      = "faceapi"
  user_assigned_identity_id = azurerm_user_assigned_identity.regula.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = module.aks.oidc_issuer_profile_issuer_url
  subject                   = "system:serviceaccount:faceapi:faceapi-sa"
}
