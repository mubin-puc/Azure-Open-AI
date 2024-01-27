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
  appID = var.appID
}

locals {
  appPassword = var.appPassword
}

locals {
  blobSASToken = var.blobSASToken
}

locals {
  resourceGroupSearch = var.resource_group_name
}

locals {
  azureSearchName = var.azureSearchName
}

locals {
  azureOpenAIName = var.azureOpenAIName
}

locals {
  azureOpenAIAPIKey = var.azureOpenAIAPIKey
}

locals {
  bingSearchName = var.bingSearchName
}

locals {
  SQLServerName = var.SQLServerName
}

locals {
  SQLServerUsername = var.SQLServerUsername
}

locals {
  SQLServerPassword = var.SQLServerPassword
}

locals {
  cosmosDBAccountName = var.cosmosDBAccountName
}

locals {
  cosmosDBContainerName = var.cosmosDBContainerName
}

locals {
  botId = "BotID-${local.unique_string}"
}

locals {
  appServicePlanName = "AppServicePlan-backend-${local.unique_string}"
}

locals {
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "botapp" {
  name                = "bot-template"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "appId": {
      "value": local.appID
    },
    "appPassword": {
      "value": local.appPassword
    },
    "blobSASToken": {
      "value": local.blobSASToken
    },
    "resourceGroupSearch": {
      "value": local.resourceGroupSearch
    },
    "azureSearchName": {
      "value": local.azureSearchName
    },
    "azureSearchAPIVersion": {
      "value": "2023-07-01-Preview"
    },
    "azureOpenAIName": {
      "value": local.azureOpenAIName
    },
    "azureOpenAIAPIKey": {
      "value": local.azureOpenAIAPIKey
    },
    "azureOpenAIModelName": {
      //"value": "gpt-4-32k"
    },
    "azureOpenAIAPIVersion": {
      "value": "2023-05-15"
    },
    "bingSearchUrl": {
      "value": "https://api.bing.microsoft.com/v7.0/search"
    },
    "bingSearchName": {
      "value": local.bingSearchName
    },
    "SQLServerName": {
      "value": local.SQLServerName
    },
    "SQLServerDatabase": {
      "value": "SampleDB"
    },
    "SQLServerUsername": {
      "value": local.SQLServerUsername
    },
    "SQLServerPassword": {
      "value": local.SQLServerPassword
    },
    "cosmosDBAccountName": {
      "value": local.cosmosDBAccountName
    },
    "cosmosDBContainerName": {
      "value": local.cosmosDBContainerName
    },
    "botId": {
      "value": local.botId
    },
    "botSKU": {
      "value": "F0"
    },
    "appServicePlanName": {
      "value": local.appServicePlanName
    },
    "appServicePlanSKU": {
      "value": "S3"
    },
    "location": {
      "value": local.location
    }
  })
  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "metadata": {
    "_generator": {
      "name": "bicep",
      "version": "0.23.1.45101",
      "templateHash": "15820469957931514877"
    }
  },
  "parameters": {
    "appId": {
      "type": "string",
      "metadata": {
        "description": "Required. Active Directory App ID."
      }
    },
    "appPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Required. Active Directory App Secret Value."
      }
    },
    "blobSASToken": {
      "type": "securestring",
      "metadata": {
        "description": "Required. The SAS token for the blob hosting your data."
      }
    },
    "resourceGroupSearch": {
      "type": "string",
      "defaultValue": "[resourceGroup().name]",
      "metadata": {
        "description": "Optional. The name of the resource group where the resources (Azure Search etc.) where deployed previously. Defaults to current resource group."
      }
    },
    "azureSearchName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the Azure Search service deployed previously."
      }
    },
    "azureSearchAPIVersion": {
      "type": "string",
      "defaultValue": "2023-07-01-Preview",
      "metadata": {
        "description": "Optional. The API version for the Azure Search service."
      }
    },
    "azureOpenAIName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the Azure OpenAI resource deployed previously."
      }
    },
    "azureOpenAIAPIKey": {
      "type": "securestring",
      "metadata": {
        "description": "Required. The API key of the Azure OpenAI resource deployed previously."
      }
    },
    "azureOpenAIModelName": {
      "type": "string",
      "defaultValue": "gpt-4-32k",
      "metadata": {
        "description": "Optional. The model name for the Azure OpenAI service."
      }
    },
    "azureOpenAIAPIVersion": {
      "type": "string",
      "defaultValue": "2023-05-15",
      "metadata": {
        "description": "Optional. The API version for the Azure OpenAI service."
      }
    },
    "bingSearchUrl": {
      "type": "string",
      "defaultValue": "https://api.bing.microsoft.com/v7.0/search",
      "metadata": {
        "description": "Optional. The URL for the Bing Search service."
      }
    },
    "bingSearchName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the Bing Search service deployed previously."
      }
    },
    "SQLServerName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the SQL server deployed previously e.g. sqlserver.database.windows.net"
      }
    },
    "SQLServerDatabase": {
      "type": "string",
      "defaultValue": "SampleDB",
      "metadata": {
        "description": "Required. The name of the SQL Server database."
      }
    },
    "SQLServerUsername": {
      "type": "string",
      "metadata": {
        "description": "Required. The username for the SQL Server."
      }
    },
    "SQLServerPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Required. The password for the SQL Server."
      }
    },
    "cosmosDBAccountName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the Azure CosmosDB."
      }
    },
    "cosmosDBContainerName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of the Azure CosmosDB container."
      }
    },
    "botId": {
      "type": "string",
      "defaultValue": "[format('BotId-{0}', uniqueString(resourceGroup().id))]",
      "metadata": {
        "description": "Optional. The globally unique and immutable bot ID. Also used to configure the displayName of the bot, which is mutable."
      }
    },
    "botSKU": {
      "type": "string",
      "defaultValue": "F0",
      "allowedValues": [
        "F0",
        "S1"
      ],
      "metadata": {
        "description": "Optional, defaults to F0. The pricing tier of the Bot Service Registration. Acceptable values are F0 and S1."
      }
    },
    "appServicePlanName": {
      "type": "string",
      "defaultValue": "[format('AppServicePlan-Backend-{0}', uniqueString(resourceGroup().id))]",
      "metadata": {
        "description": "Optional. The name of the new App Service Plan."
      }
    },
    "appServicePlanSKU": {
      "type": "string",
      "defaultValue": "S3",
      "allowedValues": [
        "B3",
        "S3",
        "P2v3"
      ],
      "metadata": {
        "description": "Optional, defaults to S3. The SKU of the App Service Plan. Acceptable values are B3, S3 and P2v3."
      }
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]",
      "metadata": {
        "description": "Optional, defaults to resource group location. The location of the resources."
      }
    }
  },
  "variables": {
    "publishingUsername": "[format('${0}', parameters('botId'))]",
    "webAppName": "[format('webApp-Backend-{0}', parameters('botId'))]",
    "siteHost": "[format('{0}.azurewebsites.net', variables('webAppName'))]",
    "botEndpoint": "[format('https://{0}/api/messages', variables('siteHost'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2022-09-01",
      "name": "[parameters('appServicePlanName')]",
      "location": "[parameters('location')]",
      "sku": {
        "name": "[parameters('appServicePlanSKU')]"
      },
      "kind": "linux",
      "properties": {
        "reserved": true
      }
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2022-09-01",
      "name": "[variables('webAppName')]",
      "location": "[parameters('location')]",
      "tags": {
        "azd-service-name": "backend"
      },
      "kind": "app,linux",
      "properties": {
        "enabled": true,
        "hostNameSslStates": [
          {
            "name": "[format('{0}.azurewebsites.net', variables('webAppName'))]",
            "sslState": "Disabled",
            "hostType": "Standard"
          },
          {
            "name": "[format('{0}.scm.azurewebsites.net', variables('webAppName'))]",
            "sslState": "Disabled",
            "hostType": "Repository"
          }
        ],
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', parameters('appServicePlanName'))]",
        "reserved": true,
        "scmSiteAlsoStopped": false,
        "clientAffinityEnabled": false,
        "clientCertEnabled": false,
        "hostNamesDisabled": false,
        "containerSize": 0,
        "dailyMemoryTimeQuota": 0,
        "httpsOnly": false,
        "siteConfig": {
          "appSettings": [
            {
              "name": "MicrosoftAppId",
              "value": "[parameters('appId')]"
            },
            {
              "name": "MicrosoftAppPassword",
              "value": "[parameters('appPassword')]"
            },
            {
              "name": "BLOB_SAS_TOKEN",
              "value": "[parameters('blobSASToken')]"
            },
            {
              "name": "AZURE_SEARCH_ENDPOINT",
              "value": "[format('https://{0}.search.windows.net', parameters('azureSearchName'))]"
            },
            {
              "name": "AZURE_SEARCH_KEY",
              "value": "[listAdminKeys(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupSearch')), 'Microsoft.Search/searchServices', parameters('azureSearchName')), '2021-04-01-preview').primaryKey]"
            },
            {
              "name": "AZURE_SEARCH_API_VERSION",
              "value": "[parameters('azureSearchAPIVersion')]"
            },
            {
              "name": "AZURE_OPENAI_ENDPOINT",
              "value": "[format('https://{0}.openai.azure.com/', parameters('azureOpenAIName'))]"
            },
            {
              "name": "AZURE_OPENAI_API_KEY",
              "value": "[parameters('azureOpenAIAPIKey')]"
            },
            {
              "name": "AZURE_OPENAI_MODEL_NAME",
              "value": "[parameters('azureOpenAIModelName')]"
            },
            {
              "name": "AZURE_OPENAI_API_VERSION",
              "value": "[parameters('azureOpenAIAPIVersion')]"
            },
            {
              "name": "BING_SEARCH_URL",
              "value": "[parameters('bingSearchUrl')]"
            },
            {
              "name": "BING_SUBSCRIPTION_KEY",
              "value": "[listKeys(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupSearch')), 'Microsoft.Bing/accounts', parameters('bingSearchName')), '2020-06-10').key1]"
            },
            {
              "name": "SQL_SERVER_NAME",
              "value": "[parameters('SQLServerName')]"
            },
            {
              "name": "SQL_SERVER_DATABASE",
              "value": "[parameters('SQLServerDatabase')]"
            },
            {
              "name": "SQL_SERVER_USERNAME",
              "value": "[parameters('SQLServerUsername')]"
            },
            {
              "name": "SQL_SERVER_PASSWORD",
              "value": "[parameters('SQLServerPassword')]"
            },
            {
              "name": "AZURE_COSMOSDB_ENDPOINT",
              "value": "[format('https://{0}.documents.azure.com:443/', parameters('cosmosDBAccountName'))]"
            },
            {
              "name": "AZURE_COSMOSDB_NAME",
              "value": "[parameters('cosmosDBAccountName')]"
            },
            {
              "name": "AZURE_COSMOSDB_CONTAINER_NAME",
              "value": "[parameters('cosmosDBContainerName')]"
            },
            {
              "name": "AZURE_COMOSDB_CONNECTION_STRING",
              "value": "[listConnectionStrings(extensionResourceId(format('/subscriptions/{0}/resourceGroups/{1}', subscription().subscriptionId, parameters('resourceGroupSearch')), 'Microsoft.DocumentDB/databaseAccounts', parameters('cosmosDBAccountName')), '2023-04-15').connectionStrings[0].connectionString]"
            },
            {
              "name": "SCM_DO_BUILD_DURING_DEPLOYMENT",
              "value": "true"
            }
          ],
          "cors": {
            "allowedOrigins": [
              "https://botservice.hosting.portal.azure.net",
              "https://hosting.onecloud.azure-test.net/"
            ]
          }
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', parameters('appServicePlanName'))]"
      ]
    },
    {
      "type": "Microsoft.Web/sites/config",
      "apiVersion": "2022-09-01",
      "name": "[format('{0}/{1}', variables('webAppName'), 'web')]",
      "properties": {
        "numberOfWorkers": 1,
        "defaultDocuments": [
          "Default.htm",
          "Default.html",
          "Default.asp",
          "index.htm",
          "index.html",
          "iisstart.htm",
          "default.aspx",
          "index.php",
          "hostingstart.html"
        ],
        "netFrameworkVersion": "v4.0",
        "phpVersion": "",
        "pythonVersion": "",
        "nodeVersion": "",
        "linuxFxVersion": "PYTHON|3.10",
        "requestTracingEnabled": false,
        "remoteDebuggingEnabled": false,
        "remoteDebuggingVersion": "VS2017",
        "httpLoggingEnabled": true,
        "logsDirectorySizeLimit": 35,
        "detailedErrorLoggingEnabled": false,
        "publishingUsername": "[variables('publishingUsername')]",
        "scmType": "None",
        "use32BitWorkerProcess": true,
        "webSocketsEnabled": false,
        "alwaysOn": true,
        "appCommandLine": "gunicorn --bind 0.0.0.0 --worker-class aiohttp.worker.GunicornWebWorker --timeout 600 app:APP",
        "managedPipelineMode": "Integrated",
        "virtualApplications": [
          {
            "virtualPath": "/",
            "physicalPath": "site\\wwwroot",
            "preloadEnabled": false,
            "virtualDirectories": null
          }
        ],
        "loadBalancing": "LeastRequests",
        "experiments": {
          "rampUpRules": []
        },
        "autoHealEnabled": false,
        "vnetName": "",
        "minTlsVersion": "1.2",
        "ftpsState": "AllAllowed"
      },
      "dependsOn": [
        "[resourceId('Microsoft.Web/sites', variables('webAppName'))]"
      ]
    },
    {
      "type": "Microsoft.BotService/botServices",
      "apiVersion": "2022-09-15",
      "name": "[parameters('botId')]",
      "location": "global",
      "kind": "azurebot",
      "sku": {
        "name": "[parameters('botSKU')]"
      },
      "properties": {
        "displayName": "[parameters('botId')]",
        "iconUrl": "https://docs.botframework.com/static/devportal/client/images/bot-framework-default.png",
        "endpoint": "[variables('botEndpoint')]",
        "msaAppId": "[parameters('appId')]",
        "luisAppIds": [],
        "schemaTransformationVersion": "1.3",
        "isCmekEnabled": false
      },
      "dependsOn": [
        "[resourceId('Microsoft.Web/sites', variables('webAppName'))]"
      ]
    }
  ],
  "outputs": {
    "botServiceName": {
      "type": "string",
      "value": "[parameters('botId')]"
    },
  
    "webAppName": {
      "type": "string",
      "value": "[variables('webAppName')]"
    },
    "webAppUrl": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Web/sites', variables('webAppName')), '2022-09-01').defaultHostName]"
    }
  }
}
TEMPLATE

  // NOTE: whilst we show an inline template here, we recommend
  // sourcing this from a file for readability/editor support
}