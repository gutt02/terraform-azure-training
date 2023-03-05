# Output Values

```hcl
output "dependencies" {
  value = {}

  depends_on = [
    azurerm_mssql_server.mssql_server,
    azurerm_mssql_database.mssql_database_mssql_server,
    azurerm_mssql_firewall_rule.firewall_rule_mssql_server
  ]
}
```

* Rückgabe von Resource-Attributen
  * Resource IDs
  * IP-Addressen
  * Usernamen
  * Sensitive Informationen, z.B. Passwörter
  * Ausführen von
    * `terraform apply`
    * `terraform output`
    * `terraform output <variable_name>`

## Aufgabe

* Sensitive Ausgabe des Access Keys des Storage Accounts.
* Ausgabe des Namens des Storage Accounts.

## Beispiel

`main.tf`
```hcl
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

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = "tf-training-GUTT02-rg"
  location            = var.location

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

`outputs.tf`
```hcl
output "..." {
  value       = ...
  description = "Name of the Storage Account."
}

output "..." {
  value       = ...
  description = "Storage Account Access Key."
  sensitive   = ...
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [Define Input Variables](https://learn.hashicorp.com/tutorials/terraform/azure-variables)
* [Input Variables](https://www.terraform.io/docs/language/values/variables.html)
* [Local Values](https://www.terraform.io/docs/language/values/locals.html)
