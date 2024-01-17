resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_cognitive_account" "cognitive-account" {
  kind                = "CognitiveServices"
  location            = var.location
  name                = var.cognitive_services_name
  resource_group_name = var.resource_group_name
  sku_name            = "S0"
}

resource "azurerm_cognitive_account" "cognitive-account-2" {
  kind                = "FormRecognizer"
  location            = var.location
  name                = var.formRecognizer_name
  resource_group_name = var.resource_group_name
  sku_name            = "S0"
}

resource "azurerm_cosmosdb_account" "cosmosdb-account" {
  location            = var.location
  name                = var.cosmodb_account_name
  offer_type          = "Standard"
  resource_group_name = var.resource_group_name
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb-sql-db" {
  account_name        = var.cosmodb_account_name
  name                = var.cosmosdb_database
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_account.cosmosdb-account,
  ]
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb-sql-container" {
  account_name          = var.cosmodb_account_name
  database_name         = var.cosmosdb_database
  name                  = var.cosmosdb_container
  partition_key_path    = "/user_id"
  partition_key_version = 2
  resource_group_name   = var.resource_group_name
  depends_on = [
    azurerm_cosmosdb_sql_database.cosmosdb-sql-db,
  ]
}

resource "azurerm_cosmosdb_sql_role_definition" "comosdb-role" {
  account_name        = var.cosmodb_account_name
  assignable_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${var.cosmodb_account_name}"]
  name                = "Cosmos DB Data Reader AI"
  resource_group_name = var.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
  depends_on = [
    azurerm_cosmosdb_account.cosmosdb-account,
  ]
}

resource "azurerm_cosmosdb_sql_role_definition" "cosmosdb-role2" {
  account_name        = var.cosmodb_account_name
  assignable_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${var.cosmodb_account_name}"]
  name                = "Cosmos DB Data Contributor AI"
  resource_group_name = var.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
  depends_on = [
    azurerm_cosmosdb_account.cosmosdb-account,
  ]
}

resource "azurerm_search_service" "search-service" {
  location            = var.location
  name                = var.search_service_name
  resource_group_name = var.resource_group_name
  sku                 = "standard"
}

resource "azurerm_mssql_server" "mssql-server" {
  administrator_login          = var.admin_user
  administrator_login_password = "mubin@765#*aa"
  location                     = var.location
  minimum_tls_version          = "Disabled"
  name                         = var.mssql_server_name
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
}

resource "azurerm_mssql_database" "mssql-database" {
  name      = "SampleDB"
  server_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_mssql_database_extended_auditing_policy" "mssql-policy" {
  database_id            = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}/databases/SampleDB"
  enabled                = false
  log_monitoring_enabled = false
  depends_on = [
    azurerm_mssql_database.mssql-database,
  ]
}


resource "azurerm_mssql_server_microsoft_support_auditing_policy" "mssql-policy1" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_mssql_server_transparent_data_encryption" "mssql-policy4" {
  server_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_mssql_server_extended_auditing_policy" "mssql-policy5" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_mssql_firewall_rule" "firewall-rule" {
  end_ip_address   = "255.255.255.255"
  name             = "AllowAllAzureIPs"
  server_id        = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Sql/servers/${var.mssql_server_name}"
  start_ip_address = "0.0.0.0"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_mssql_server_security_alert_policy" "alert-policy" {
  resource_group_name = var.resource_group_name
  server_name         = var.mssql_server_name
  state               = "Disabled"
  depends_on = [
    azurerm_mssql_server.mssql-server,
  ]
}

resource "azurerm_storage_account" "storage-account" {
  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  location                         = "eastus"
  min_tls_version                  = "TLS1_0"
  name                             = var.storage_account_name
  resource_group_name              = var.resource_group_name
}

resource "azurerm_storage_container" "storage-container" {
  name                 = "books"
  storage_account_name = var.storage_account_name
  depends_on = [
    azurerm_storage_account.storage-account
  ]
}

resource "azurerm_storage_container" "storage-container1" {
  name                 = "cord19"
  storage_account_name = var.storage_account_name
   depends_on = [
    azurerm_storage_account.storage-account
  ]
}

resource "azurerm_storage_container" "storage-container2" {
  name                 = "mixed"
  storage_account_name = var.storage_account_name
   depends_on = [
    azurerm_storage_account.storage-account
  ]
}

