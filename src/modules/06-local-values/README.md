# Local Values

```hcl
locals {
  # detect OS
  # Directories start with "C:..." on Windows; All other OSs use "/" for root.
  is_windows                       = substr(pathexpand("~"), 0, 1) == "/" ? false : true
  managed_private_endpoint_enabled = var.environment_is_private
  private_endpoint_enabled         = var.environment_is_private

  mssql_database = flatten([
    for mssql_server_key, mssql_server in data.azurerm_mssql_server.mssql_server : [
      for mssql_database_key, mssql_database in data.azurerm_mssql_database.mssql_database : {
        key                = "${lower(replace(mssql_server.name, " ", "_"))}.${lower(replace(mssql_database.name, " ", "_"))}"
        mssql_server_key   = mssql_server_key
        mssql_database_key = mssql_database_key
        mssql_server       = mssql_server
        mssql_database     = mssql_database
      } if var.module_enabled && var.synapse_workspace.is_enabled && mssql_database.server_id == mssql_server.id
    ]
  ])

  role_assignments_synapse_workspace = flatten([
    for security_group_key, security_group in var.security_groups : [
      for object_key, object_id in security_group.object_ids : [
        for role_key, role in security_group.role_assignments.synapse_workspace : {
          key                = "${lower(replace(security_group.name, " ", "_"))}.${lower(replace(role, " ", "_"))}.${lower(replace(azurerm_synapse_workspace.synapse_workspace[0].name, " ", "_"))}.${object_key}"
          security_group_key = security_group_key
          role_key           = role_key
          resource_key       = azurerm_synapse_workspace.synapse_workspace[0].name
          name               = security_group.name
          object_id          = object_id
          role               = role
          scope              = azurerm_synapse_workspace.synapse_workspace[0].id
        } if try(azurerm_synapse_workspace.synapse_workspace[0].tags.role_assignment_enabled, false)
    ]]
  ])
}
```

## Aufgabe

* Definieren eines lokalen Werts (Variable, Konstante) für die Region
  * Input Variables entsprechen Funktionsargumenten
  * Output Values sind Rückgabewerte der Funktion
  * Local Values sind wie temporäre lokale Variablen einer Funktion
  * Anm.: Sind dateiübergreifend gültig

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

locals {
  my_location = ...
}

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = "tf-training-gutt02-rg"
  location            = ...

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.strg.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "hello.txt"
  storage_account_name   = azurerm_storage_account.strg.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "./data/hello.txt"
}
```

`variables.tf`
```hcl
variable "location" {
  type        = string
  default     = "westeurope"
  description = "Azure Region."
}

variable "tags" {
  type = object({
    created_by  = string
    project     = string
    customer_no = number
  })

  description = "Tags for Azure resources."
}
```

`env.tfvars`
```hcl
tags = {
  created_by  = "gutt02@asyscsp.onmicrosoft.com"
  project     = "cap6"
  customer_no = 4250
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [Define Input Variables](https://learn.hashicorp.com/tutorials/terraform/azure-variables)
* [Input Variables](https://www.terraform.io/docs/language/values/variables.html)
* [Local Values](https://www.terraform.io/docs/language/values/locals.html)
