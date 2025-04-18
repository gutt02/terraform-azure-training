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
  racf        = "gutt02"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "this" {
  name     = "tf-training-${local.racf}-rg"
  location = var.location

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "this" {
  name                = "tftra${local.racf}sa01"
  location            = azurerm_resource_group.this.location != local.my_location ? azurerm_resource_group.this.location : local.my_location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    racf = "${local.racf}"

    is_racf = local.racf == "gutt02" ? "true" : "false"

    eot = <<EOT
Test EOT
EOT

    eot2 = <<-EOT
      Test EOT w/o indentation.
    EOT

    testing_if = "Hello, %{if local.racf != ""}${local.racf}%{else}unknown%{endif}!"
  }
}
