output "storage_account_name" {
  value       = module.storage_account.storage_account_name
  description = "Storage Account Name."
}

output "storage_account_primary_access_key" {
  value       = module.storage_account.storage_account_primary_access_key
  sensitive   = true
  description = "Primary Access Key of the Storage Account."
}
