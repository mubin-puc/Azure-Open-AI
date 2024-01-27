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
  webAppName = "Web-App-${local.unique_string}"
}

locals {
  location = var.location
}

locals {
  appServicePlanName = "AppServicePlan-frontend-${local.unique_string}"
}

locals {
  botServiceName = var.botServiceName
}

locals {
  botDirectLineChannelKey = var.botDirectLineChannelKey
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

resource "azurerm_resource_group_template_deployment" "frontend" {
  name                = "frontend-template"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "webAppName": {
      "value": local.webAppName
    },
    "appServicePlanSKU": {
      "value": "S3"
    },
    "appServicePlanName": {
      "value": local.appServicePlanName
    },
    "botServiceName": {
      "value": local.botServiceName
    },
    "botDirectLineChannelKey": {
      "value": local.botDirectLineChannelKey
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
      "templateHash": "6332436063003351938"
    }
  },
  "parameters": {
    "webAppName": {
      "type": "string",
      "defaultValue": "[format('webApp-Frontend-{0}', uniqueString(resourceGroup().id))]",
      "minLength": 2,
      "maxLength": 60,
      "metadata": {
        "description": "Optional. Web app name must be between 2 and 60 characters."
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
        "description": "Optional, defaults to S3. The SKU of App Service Plan. The allowed values are B3, S3 and P2v3."
      }
    },
    "appServicePlanName": {
      "type": "string",
      "defaultValue": "[format('AppServicePlan-Frontend-{0}', uniqueString(resourceGroup().id))]",
      "metadata": {
        "description": "Optional. The name of the App Service Plan."
      }
    },
    "botServiceName": {
      "type": "string",
      "metadata": {
        "description": "Required. The name of your Bot Service."
      }
    },
    "botDirectLineChannelKey": {
      "type": "securestring",
      "metadata": {
        "description": "Required. The key to the direct line channel of your bot."
      }
    },
    "blobSASToken": {
      "type": "securestring",
      "metadata": {
        "description": "Required. The SAS token for the Azure Storage Account hosting your data"
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
        "description": "Optional. The API version of the Azure Search."
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
        "description": "Optional. The model name of the Azure OpenAI."
      }
    },
    "azureOpenAIAPIVersion": {
      "type": "string",
      "defaultValue": "2023-05-15",
      "metadata": {
        "description": "Optional. The API version of the Azure OpenAI."
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
      "name": "[parameters('webAppName')]",
      "tags": {
        "azd-service-name": "frontend"
      },
      "location": "[parameters('location')]",
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', parameters('appServicePlanName'))]",
        "siteConfig": {
          "appSettings": [
            {
              "name": "BOT_SERVICE_NAME",
              "value": "[parameters('botServiceName')]"
            },
            {
              "name": "BOT_DIRECTLINE_SECRET_KEY",
              "value": "[parameters('botDirectLineChannelKey')]"
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
              "name": "SCM_DO_BUILD_DURING_DEPLOYMENT",
              "value": "true"
            }
          ]
        }
      },
      "dependsOn": [
        "[resourceId('Microsoft.Web/serverfarms', parameters('appServicePlanName'))]"
      ]
    },
    {
      "type": "Microsoft.Web/sites/config",
      "apiVersion": "2022-09-01",
      "name": "[format('{0}/{1}', parameters('webAppName'), 'web')]",
      "properties": {
        "linuxFxVersion": "PYTHON|3.10",
        "alwaysOn": true,
        "appCommandLine": "python -m streamlit run Home.py --server.port 8000 --server.address 0.0.0.0"
      },
      "dependsOn": [
        "[resourceId('Microsoft.Web/sites', parameters('webAppName'))]"
      ]
    }
  ],
  "outputs": {
    "webAppURL": {
      "type": "string",
      "value": "[reference(resourceId('Microsoft.Web/sites', parameters('webAppName')), '2022-09-01').defaultHostName]"
    },
    "webAppName": {
      "type": "string",
      "value": "[parameters('webAppName')]"
    }
  }
}
TEMPLATE

  // NOTE: whilst we show an inline template here, we recommend
  // sourcing this from a file for readability/editor support
}
