resource "azurerm_cognitive_account" "account" {
  name                = var.name
  location            = var.location
  tags                = var.tags
  kind                = var.kind
  resource_group_name = var.resource_group_name
  public_network_access_enabled  = true
  sku_name               = var.sku
}

resource "azurerm_cognitive_deployment" "deployment1" {
  name                 = "gpt-35-turbo"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0613"
  }
  scale {
    type = "Standard"
  }
  
}

resource "azurerm_cognitive_deployment" "deployment2" {
  name                 = "gpt-35-turbo-16k"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo-16k"
    version = "0613"
  }
  scale {
    type = "Standard"
  }
}

resource "azurerm_cognitive_deployment" "deployment3" {
  name                 = "gpt-4"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "0613"
  }
  scale {
    type = "Standard"
  }
}

resource "azurerm_cognitive_deployment" "deployment4" {
  name                 = "gpt-4-turbo"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "gpt-4"
    version = "1106-Preview"
  }
  scale {
    type = "Standard"
  }
}

resource "azurerm_cognitive_deployment" "deployment5" {
  name                 = "gpt-4-32k"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "gpt-4-32k"
    version = "0613"
  }
  scale {
    type = "Standard"
  }
}

resource "azurerm_cognitive_deployment" "embedding1" {
  name                 = "text-embedding-ada-002"
  cognitive_account_id = azurerm_cognitive_account.account.id
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    type = "Standard"
  }
}