variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "resource_group_name" {
    description = "existing resource group name"
}

variable "azureSearchSKU" {
    default = "standard"
}

variable "azureSearchReplicaCount"{
    default = "1"
}

variable "azureSearchPartitionCount"{
    default = "1"
}

variable "azureSearchHostingMode"{
    default = "default"
}

variable "cognitiveServiceSKU"{
    default = "S0"
}

variable "SQLAdministratorLogin" {
    default = "user013"
}

variable "SQLAdministratorLoginPassword" {
    default = "assdf@1234"
}

variable "SQLDBName"{
    default = "SampleDB"
}

variable "subscription_id" {
    default = "738384b4-b096-477c-967f-0737aa9b673a"
}