terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.42.0"

    }
  }

  required_version = ">= 1.2.8"
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
  location = "westeurope"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                = "tftragutt02sa01"
  location            = "westeurope"
  resource_group_name = "tf-training-gutt02-rg"

  account_tier             = "Standard"
  account_replication_type = "ZRS"

  depends_on = [
    azurerm_resource_group.this
  ]
}
