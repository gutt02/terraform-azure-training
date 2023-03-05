# Input Variables in Terraform

```hcl
variable "mssql_server" {
  type = object({
    azuread_authentication_only   = bool
    public_network_access_enabled = bool
    is_enabled                    = bool
    suffix                        = string
    version                       = string

    elastic_pool = object({
      is_enabled                         = bool
      license_type                       = string
      max_size_gb                        = number
      sku_name                           = string
      sku_tier                           = string
      sku_family                         = string
      sku_capacity                       = number
      per_database_settings_min_capacity = number
      per_database_settings_max_capacity = number
    })

    databases = list(object({
      name                        = string
      collation                   = string
      sku_name                    = string
      integration_runtime         = string
      linked_service_enabled      = bool
      synapse_integration_runtime = string
    }))
  })

  description = "Configuration of Azure SQL Database"
}

variable "sql_admin_login" {
  type        = string
  default     = null
  description = "SQL Admin login"
}

variable "sql_admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "SQL Admin password"
}
```

## Aufgabe

* Definieren einer Variablen für die Region (Type string)
* Definieren einer Variable für die Tags (Type object)
* Definieren eines Standardwerts für die Variable
* Datei `variables.tf` bei Bedarf
* Variablenübergabe
  * Standardwert
  * Prompt
  * Parameter: `-var=name=value`
  * Umgebungsvariable:</br>
    `$ENV:TF_VAR_location="northeurope"`</br>
    `$ENV:TF_VAR_location=$null`
  * tfvars-File:
    * Standarddatei: `terraform.tfvars`
    * Parameter: `-var-file="env.tfvars"`
* Reihenfolge
  * Umgebungsvariable
  * `terraform.tfvars` Datei
  * `terraform.tfvars.json` Datei
  * `*.auto.tfvars` oder `*.auto.tfvars.json` Datei
  * Parameter `-var` und `-var-file` in der angegebenen Reihenfolge
  * 'terraform plan --var-file=.\env.tfvars --var=location=northeurope`

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

locals {
  my_location = "germanywestcentral"
}

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = "tf-training-GUTT02-rg"
  location            = local.my_location

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
  ...
  description = "Azure Region."
}

variable "tags" {
  type = object({
    ...
  })

  description = "Tags for Azure resources."
}
```

`env.tfvars`
```hcl
tags = {
  ...
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [Define Input Variables](https://learn.hashicorp.com/tutorials/terraform/azure-variables)
* [Input Variables](https://www.terraform.io/docs/language/values/variables.html)
