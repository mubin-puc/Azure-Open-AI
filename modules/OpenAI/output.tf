
output "openai_id" {
  description = "The ID of the Cognitive Service Account."
  value       = azurerm_cognitive_account.account.id
}

output "openai_primary_key" {
  description = "The primary access key for the Cognitive Service Account."
  sensitive   = true
  value       = azurerm_cognitive_account.account.primary_access_key
}

output "openai_endpoint" {
  description = "The endpoint used to connect to the Cognitive Service Account."
  value       = azurerm_cognitive_account.account.endpoint
}

output "openai_name" {
  value = azurerm_cognitive_account.account.name
}