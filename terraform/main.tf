# ========================================================================
# ==========================  Resource Group  ============================
# ========================================================================
resource "azurerm_resource_group" "rg" {
  name     = "plygnd-arg-webscraper-w2"
  location = "westus2"
}

# ========================================================================
# ==========================  Storage Account ============================
# ========================================================================
resource "azurerm_storage_account" "sa" {
  name                     = "sawebscraperfaban"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ========================================================================
# ==========================  App Service Plan  ==========================
# ========================================================================
resource "azurerm_app_service_plan" "asp" {
  name                = "asp-webscraperfa"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

# ========================================================================
# ==========================  App Insights  ==============================
# ========================================================================
resource "azurerm_application_insights" "ai" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# ========================================================================
# ==========================  Function App  ==============================
# ========================================================================
resource "azurerm_function_app" "fa" {
  name                       = "fa-webscraper"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  https_only = true

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1",
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNETION_STRING" = azurerm_application_insights.ai.id
    # secrets...
    "SendGridApiKey" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.SendGridApiKey.id})"
    "SubscriptionId" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.SubscriptionId.id})"
    "TenantId"       = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.TenantId.id})"
  }

}

# ========================================================================
# ==========================  Key Vault  =================================
# ========================================================================
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "bnissenkeyvaultt"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenantId
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "None"
  }

  access_policy {
    tenant_id = var.tenantId
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Set",
    ]
  }
}

# ========================================================================
# ==========================  Key Vault Access Policy  ===================
# ========================================================================
resource "azurerm_key_vault_access_policy" "funcAppAccessPolicy" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id = azurerm_function_app.fa.identity.0.tenant_id
  object_id = azurerm_function_app.fa.identity.0.principal_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
  ]
}

# ========================================================================
# ==========================  Key Vault Secrets  =========================
# ========================================================================
resource "azurerm_key_vault_secret" "SendGridApiKey" {
  name         = "SendGridApiKey"
  value        = var.sendGridApiKey
  key_vault_id = azurerm_key_vault.kv.id
}
resource "azurerm_key_vault_secret" "SubscriptionId" {
  name         = "SubscriptionId"
  value        = var.subscriptionId
  key_vault_id = azurerm_key_vault.kv.id
}
resource "azurerm_key_vault_secret" "TenantId" {
  name         = "TenantId"
  value        = var.tenantId
  key_vault_id = azurerm_key_vault.kv.id
}