variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
  default = "eastus"
}

variable "subscription_id" {
  default = "738384b4-b096-477c-967f-0737aa9b673a"

}

variable "tenant_id" {
  description = "The tenant id of the Azure subscription"
  default     = "0745fa48-0122-45b6-bde7-8626f6f84df6"
  type        = string
}

variable "appID" {
 default = "e461c789-8aa4-41e1-b6c6-20f35eeb5bb6"
}

variable "appPassword" {
  default = "yew8Q~AJhebbUQqP8hGzqTs2im_ZFJ8Ctanxybv2"
}

variable "botDirectLineChannelKey" {
  
}