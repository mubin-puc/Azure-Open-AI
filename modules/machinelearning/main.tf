data "azurerm_client_config" "current" {}

resource "random_string" "value" {
  length  = 4
  upper   = false
  lower   = true
  special = false
  numeric = false
}

locals {
  unique_string = substr(md5(random_string.value.result), 0, 8)
}

resource "azurerm_application_insights" "app-insights" {
  name                = "ws-insights-${local.unique_string}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}

resource "azurerm_key_vault" "keyvault" {
  name                = "keyvault-${local.unique_string}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "storage-ml" {
  name                     = "storage${local.unique_string}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "mlws-cr" {
  name                = "mlws${local.unique_string}cr"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azurerm_machine_learning_workspace" "ml-workspace" {
  name                    = "workspace-${local.unique_string}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = azurerm_application_insights.app-insights.id
  key_vault_id            = azurerm_key_vault.keyvault.id
  storage_account_id      = azurerm_storage_account.storage-ml.id
  container_registry_id   = azurerm_container_registry.mlws-cr.id
  public_network_access_enabled = true
  identity {
    type = "SystemAssigned"
  }
}