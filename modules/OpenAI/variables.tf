variable "name" {
  type        = string
  description = "Name of the Azure Cognitive Services instance."
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "Location for the Azure Cognitive Services instance."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the Azure Cognitive Services instance."
}

variable "kind" {
  type        = string
  default     = "OpenAI"
  description = "Kind of the Azure Cognitive Services instance."
}

variable "sku" {
  type        = string
  description = "pricing tier"
  default     = "S0"
}