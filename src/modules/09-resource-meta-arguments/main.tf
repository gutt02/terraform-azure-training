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
  my_location = "germanywestcentral"

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
  name     = "tf-training-${local.racf}-rg"
  location = locat.my_location

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                = "tftra${local.racf}sa01"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
resource "azurerm_storage_container" "this" {
  count = 4

  name                  = "data-${count.index}"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob
resource "azurerm_storage_blob" "this" {
  for_each = {
    for blob in local.blobs : blob.name => blob
  }

  name                   = each.value.name
  storage_account_name   = azurerm_storage_account.this.name
  storage_container_name = each.value.container
  type                   = "Block"
  source                 = "./data/hello.txt"

  depends_on = [
    azurerm_storage_container.this
  ]
}
