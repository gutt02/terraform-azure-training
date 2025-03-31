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
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "this" {
  name     = "tf-training-${local.racf}-rg"
  location = var.location

  tags = var.tags
}

module "storage_account" {
  source = "./modules/storage-account"

  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}
