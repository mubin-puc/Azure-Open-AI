output "arm_bing_output" {
  value = jsondecode(azurerm_resource_group_template_deployment.bing.output_content).name.value
}

output "searchservice_name" {
    value = azurerm_search_service.search.name
}

output "mssql-server" {
  value = azurerm_mssql_server.mssqlserver.name
}

output "server-username" {
  value = azurerm_mssql_server.mssqlserver.administrator_login
}

output "server-password" {
  value = azurerm_mssql_server.mssqlserver.administrator_login_password
}

output "cosmosdb-account" {
  value = azurerm_cosmosdb_account.cosmosdb.name
}

output "cosmosdb-container" {
  value = azurerm_cosmosdb_sql_container.cosmosdb_container.name
}

output "sas_url_query_string" {
  value = data.azurerm_storage_account_sas.sas-token.sas
}