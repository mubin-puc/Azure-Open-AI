output "bot_name" {
  value = jsondecode(azurerm_resource_group_template_deployment.botapp.output_content).botServiceName.value
}

output "webapp_name" {
  value = jsondecode(azurerm_resource_group_template_deployment.botapp.output_content).webAppName.value
}

output "webapp_url" {
  value = jsondecode(azurerm_resource_group_template_deployment.botapp.output_content).webAppUrl.value
}