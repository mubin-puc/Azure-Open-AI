resource "random_string" "value" {
  length  = 4
  upper   = false
  lower   = true
  special = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${random_string.value.result}"
  location = var.location
}

module "ai"{
  source              = "./modules/OpenAi"
  name                = "${azurerm_resource_group.rg.name}-Openai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  depends_on          = [azurerm_resource_group.rg]
}

module "deployment-01" {
    source = "./modules/deployment1"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location
    depends_on          = [module.ai]
}

module "deployment-02" {
    source = "./modules/backend"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location
    appID = var.appID
    appPassword = var.appPassword
    blobSASToken = module.deployment-01.sas_url_query_string
    azureOpenAIName = module.ai.openai_name
    azureOpenAIAPIKey = module.ai.openai_primary_key
    azureSearchName = module.deployment-01.searchservice_name
    bingSearchName = module.deployment-01.arm_bing_output
    SQLServerName = module.deployment-01.mssql-server
    SQLServerUsername = module.deployment-01.server-username
    SQLServerPassword = module.deployment-01.server-password
    cosmosDBAccountName = module.deployment-01.cosmosdb-account
    cosmosDBContainerName = module.deployment-01.cosmosdb-container
    depends_on = [module.ai,module.deployment-01]
}

module "deployment-03" {
    source = "./modules/frontend"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location
    blobSASToken = module.deployment-01.sas_url_query_string
    botServiceName = module.deployment-02.bot_name
    botDirectLineChannelKey = var.botDirectLineChannelKey
    azureSearchName = module.deployment-01.searchservice_name
    azureOpenAIName = module.ai.openai_name
    azureOpenAIAPIKey = module.ai.openai_primary_key
    depends_on = [module.deployment-01, module.deployment-02]
    
}

module "deployment-04" {
  source = "./modules/machinelearning"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

module "deployment-05" {
  source = "./modules/ml-compute"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  ws-id = module.deployment-04.ws-id
  depends_on = [module.deployment-04]
}