terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.25.0"
    }
  }

  required_version = ">= 1.9.8"
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "this" {
  name     = "tf-training-gutt02-rg"
  location = var.location

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                = "tftragutt02sa01"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "log" {
  name                = "tftragutt02sa02"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories
data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_storage_account.this.id
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting
resource "azurerm_monitor_diagnostic_setting" "this" {
  name               = "Diagnostic"
  target_resource_id = "${azurerm_storage_account.this.id}/blobServices/default"
  storage_account_id = azurerm_storage_account.log.id

  log_analytics_destination_type = "AzureDiagnostics"

  dynamic "enabled_log" {
    # for_each = data.azurerm_monitor_diagnostic_categories.this.log_category_types
    for_each = toset(["StorageRead", "StorageWrite", "StorageDelete"])

    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  metric {
    category = "Transaction"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}
