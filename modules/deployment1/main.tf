resource "random_string" "value" {
  length  = 4
  upper   = false
  lower   = true
  special = false
}

locals {
  unique_string = substr(md5(random_string.value.result), 0, 8)
}

locals {
  bing_name = "bing_search_${local.unique_string}"
}

locals {
  bing_sku = "S1"
}

resource "azurerm_search_service" "search" {
  name     = "cog-search-${local.unique_string}"
  location = var.location
  sku      = var.azureSearchSKU
  replica_count      = var.azureSearchReplicaCount
  partition_count    = var.azureSearchPartitionCount
  hosting_mode       = var.azureSearchHostingMode
  semantic_search_sku    = "standard"
  resource_group_name = var.resource_group_name
}

resource "azurerm_cognitive_account" "cognitive01" {
  name                = "cognitive-service-${local.unique_string}"
  location            = var.location
  sku_name            = var.cognitiveServiceSKU
  kind                = "CognitiveServices"
  resource_group_name = var.resource_group_name
}

resource "azurerm_mssql_server" "mssqlserver" {
  name                         = "sql-server-${local.unique_string}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.SQLAdministratorLogin
  administrator_login_password = var.SQLAdministratorLoginPassword
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name                = var.SQLDBName
  sku_name                 = "S0"
  server_id           = azurerm_mssql_server.mssqlserver.id
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_server_microsoft_support_auditing_policy" "mssqlpolicy01" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.mssqlserver.id
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_server_transparent_data_encryption" "mssql-policy02" {
  server_id = azurerm_mssql_server.mssqlserver.id
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_server_extended_auditing_policy" "mssql-policy03" {
  enabled                = false
  log_monitoring_enabled = false
  server_id              = azurerm_mssql_server.mssqlserver.id
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_server_security_alert_policy" "mssql-policy04" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.mssqlserver.name
  state               = "Disabled"
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_firewall_rule" "firewallrule" {
  name             = "AllowAllAzureIPs"
  end_ip_address   = "255.255.255.255"
  server_id        = azurerm_mssql_server.mssqlserver.id
  start_ip_address = "0.0.0.0"
  depends_on = [azurerm_mssql_server.mssqlserver]
}

resource "azurerm_mssql_database_extended_auditing_policy" "mssqldbpolicy01" {
  database_id            = azurerm_mssql_database.mssqldatabase.id
  enabled                = false
  log_monitoring_enabled = false
  depends_on = [azurerm_mssql_database.mssqldatabase]
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "cosmosdb-account-${local.unique_string}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  enable_free_tier    = false
  kind                = "GlobalDocumentDB"
  is_virtual_network_filter_enabled = false
  public_network_access_enabled     = true
  capabilities {
    name = "EnableServerless"
  }
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_database" {
  name                = "cosmosdb-db-${local.unique_string}"
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  resource_group_name = azurerm_cosmosdb_account.cosmosdb.resource_group_name
  depends_on = [azurerm_cosmosdb_account.cosmosdb]
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb_container" {
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.cosmosdb_database.name
  name                  = "cosmosdb-container-${local.unique_string}"
  partition_key_path    = "/user_id"
  partition_key_version = 2
  default_ttl = 1000
  resource_group_name = azurerm_cosmosdb_account.cosmosdb.resource_group_name
  depends_on = [azurerm_cosmosdb_sql_database.cosmosdb_database]
}

resource "azurerm_cosmosdb_sql_role_definition" "comosdb-role" {
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  assignable_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_cosmosdb_account.cosmosdb.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${azurerm_cosmosdb_account.cosmosdb.name}"]
  name                = "Cosmos DB Data Reader AI"
  resource_group_name = azurerm_cosmosdb_account.cosmosdb.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
  depends_on = [azurerm_cosmosdb_account.cosmosdb]
}

resource "azurerm_cosmosdb_sql_role_definition" "cosmosdb-role2" {
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  assignable_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_cosmosdb_account.cosmosdb.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${azurerm_cosmosdb_account.cosmosdb.name}"]
  name                = "Cosmos DB Data Contributor AI"
  resource_group_name = var.resource_group_name
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
  depends_on = [azurerm_cosmosdb_account.cosmosdb]
}

resource "azurerm_resource_group_template_deployment" "bing" {
  name                = "bingsearch-deploy"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
     "name": {
            "value": local.bing_name
        },
        "sku": {
            "value": local.bing_sku
        },
        "tagValues": {
            "value": {}
        },
        "location": {
            "value": "global"
        }
  })
  template_content = <<TEMPLATE
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "name": {
            "type": "string"
        },
        "location": {
            "type": "string"
        },
        "sku": {
            "type": "string"
        },
        "tagValues": {
            "type": "object"
        }
    },
    "resources": [
        {
            "apiVersion": "2020-06-10",
            "name": "[parameters('name')]",
            "location": "[parameters('location')]",
            "type": "Microsoft.Bing/accounts",
            "kind": "Bing.Search.v7",
            "tags": "[if(contains(parameters('tagValues'), 'Microsoft.Bing/accounts'), parameters('tagValues')['Microsoft.Bing/accounts'], json('{}'))]",
            "sku": {
                "name": "[parameters('sku')]"
            }
        }
    ],
    "outputs": {
      "name": {
      "type": "string",
      "value": "[parameters('name')]"
      }
    }
}
TEMPLATE

  // NOTE: whilst we show an inline template here, we recommend
  // sourcing this from a file for readability/editor support
}

resource "azurerm_cognitive_account" "cognitive-account-2" {
  kind                = "FormRecognizer"
  location            = var.location
  name                = "form-recog-${local.unique_string}"
  resource_group_name = var.resource_group_name
  sku_name            = "S0"
}

resource "azurerm_storage_account" "storage-account" {
  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false
  location                         = "eastus"
  min_tls_version                  = "TLS1_0"
  account_kind                     = "StorageV2"
  name                             = "${local.unique_string}"
  resource_group_name              = var.resource_group_name
}

resource "azurerm_storage_container" "storage-container" {
  name                 = "books"
  storage_account_name = azurerm_storage_account.storage-account.name
  depends_on = [azurerm_storage_account.storage-account]
}

resource "azurerm_storage_container" "storage-container1" {
  name                 = "cord19"
  storage_account_name = azurerm_storage_account.storage-account.name
   depends_on = [azurerm_storage_account.storage-account]
}

resource "azurerm_storage_container" "storage-container2" {
  name                 = "mixed"
  storage_account_name = azurerm_storage_account.storage-account.name
   depends_on = [azurerm_storage_account.storage-account]
}

data "azurerm_storage_account_sas" "sas-token" {
  connection_string = azurerm_storage_account.storage-account.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2020-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
}
