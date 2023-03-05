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

locals {
  my_location = "germanywestcentral"
  racf        = "gutt02"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "this" {
  name     = "tf-training-${local.racf}-rg"
  location = var.location

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                = "tftra${local.racf}sa01"
  location            = local.my_location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}
