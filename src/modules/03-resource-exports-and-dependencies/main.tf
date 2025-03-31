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

locals {
  racf = "gutt02"

  blobs = [
    {
      name      = "hello_0.txt"
      container = "data-0"
    },
    {
      name      = "hello_1.txt"
      container = "data-1"
    },
    {
      name      = "hello_2.txt"
      container = "data-2"
    },
    {
      name      = "hello_3.txt"
      container = "data-3"
    }
  ]
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
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
