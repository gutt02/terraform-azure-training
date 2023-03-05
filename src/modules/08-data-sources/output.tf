output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "Storage Account Name."
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
  description = "Primary Access Key of the Storage Account."
}
