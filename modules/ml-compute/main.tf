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

resource "azurerm_virtual_network" "ml-vnet" {
  name                = "vnet-${local.unique_string}"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "ml-subnet" {
  name                 = "subnet-${local.unique_string}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ml-vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_machine_learning_compute_instance" "ml-compute" {
  name                          = "compute-${local.unique_string}"
  location                      = var.location
  machine_learning_workspace_id = var.ws-id
  virtual_machine_size          = "STANDARD_DS2_V2"
  authorization_type            = "personal"
  ssh {
    public_key = var.ssh_key
  }
  subnet_resource_id = azurerm_subnet.ml-subnet.id
}

resource "azurerm_network_interface" "ml-compute-nic" {
  name                = "ml-compute-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ml-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_machine_learning_compute_instance.ml-compute]
}