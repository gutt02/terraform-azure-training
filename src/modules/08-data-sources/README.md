# Data Sources

```hcl
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "client_config" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription
data "azurerm_subscription" "subscription" {
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "subnet_prep" {
  count = var.module_enabled && var.environment_is_private ? 1 : 0

  name                 = "${var.project.customer}-${var.project.name}-${var.project.environment}-sn-${var.virtual_network.subnets.prep.name}"
  virtual_network_name = "${var.project.customer}-${var.project.name}-${var.project.environment}-vnet"
  resource_group_name  = "${var.project.customer}-${var.project.name}-${var.project.environment}-${var.resource_groups.rg_net.name}"
}
```

* Informationen von existierenden Resourcen
* Zugriff auf Attribute der entsprechenden Resource
* Ausgabe der Attribute der Resourcegroup
* Referenz des Namens und der Region in den anderen Resourcen

## Aufgabe

* Resourcengruppe referenzieren
* Namen und ggf. die Region der Resourcengruppe in der Resourcengruppe für den Storage Account referenzieren

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

data "..." "..." {
  ...
}

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = data....
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
output "storage_account_name" {
  value       = azurerm_storage_account.strg.name
  description = "Name of the Storage Account."
}

output "storage_account_primary_access_key" {
  value       = azurerm_storage_account.strg.primary_access_key
  description = "Storage Account Access Key."
  sensitive   = true
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [Data Source: azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [Define Input Variables](https://learn.hashicorp.com/tutorials/terraform/azure-variables)
* [Input Variables](https://www.terraform.io/docs/language/values/variables.html)
* [Local Values](https://www.terraform.io/docs/language/values/locals.html)
* [Data Sources](https://www.terraform.io/docs/language/data-sources/index.html)
