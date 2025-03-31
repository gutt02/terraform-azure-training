# Resource Exports & Dependencies

```hcl
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
resource "azurerm_mssql_server" "mssql_server" {
  count = var.module_enabled && var.mssql_server.is_enabled ? 1 : 0

  name                         = "${var.project.customer}-${var.project.name}-${var.project.environment}-${var.mssql_server.suffix}"
  location                     = var.location
  resource_group_name          = "${var.project.customer}-${var.project.name}-${var.project.environment}-${var.resource_groups.rg_db.name}"
  ...
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database
resource "azurerm_mssql_database" "mssql_database_mssql_server" {
  for_each = {
    for o in var.mssql_server.databases : lower(replace(o.name, " ", "_")) => o if var.module_enabled && var.mssql_server.is_enabled
  }

  name      = each.value.name
  server_id = azurerm_mssql_server.mssql_server[0].id
  ...
}
```

## Aufgabe

* Hinzufügen eines Containers zum Storage Account
* Hochladen eines Blobs in den Container
* Reference auf angelegten Storage Account

## Beispiel

`main.tf`
```hcl
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

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = "tf-training-gutt02-rg"
  location            = "westeurope"

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  tags = {
    created_by = "mysvc_gutt02@bert.group"
  }
}

resource "azurerm_storage_container" "..." {
  ...
}

resource "azurerm_storage_blob" "..." {
  ...
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
