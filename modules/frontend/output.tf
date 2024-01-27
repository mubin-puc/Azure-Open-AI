output "webapp_name" {
  value = jsondecode(azurerm_resource_group_template_deployment.frontend.output_content).webAppName.value
}

output "webapp_url" {
  value = jsondecode(azurerm_resource_group_template_deployment.frontend.output_content).webAppURL.value
}