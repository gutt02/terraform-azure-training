# Resource Meta Arguments

```hcl
resource "azurerm_log_analytics_workspace" "la" {
  count = var.module_enabled && var.log_analytics.is_enabled ? 1 : 0

  name                = "${var.project.customer}-${var.project.name}-${var.project.environment}-la"
  location            = var.location
  resource_group_name = "${var.project.customer}-${var.project.name}-${var.project.environment}-${var.resource_groups.rg_log.name}"
  sku                 = var.log_analytics.sku

  tags = {
    is_enabled               = var.log_analytics.is_enabled
    private_endpoint_enabled = local.private_endpoint_enabled
    role_assignment_enabled  = var.role_assignment_enabled
  }

  depends_on = [
    azurerm_resource_group.rg
  ]
}
```

```hcl
resource "azurerm_log_analytics_linked_storage_account" "log_analytics_linked_storage_account" {
  for_each = {
    for o in toset(["CustomLogs", "Query", "Alerts"]) : lower(replace(o, " ", "_")) => o if var.module_enabled && var.strg_log.is_enabled
  }

  data_source_type      = each.value
  resource_group_name   = azurerm_log_analytics_workspace.la[0].resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.la[0].id
  storage_account_ids   = [azurerm_storage_account.strglog[0].id]

  lifecycle {
    ignore_changes = [
      # Terraform requires lower case whereas Azure uses CamelCase
      data_source_type
    ]
  }
}
```

* Möglichkeit das Verhalten einer Resource zu beeinflussen
* Kann an jeder Resource genutzt werden
* Meta-Arguments
  * `depends_on` - Abhängigkeiten zu anderen Resourcen
  * `count` - Erstellen mehrer Resourcen für die definierte Anzahl
  * `for_each` - Erstellen mehrer Resourcen basierend auf einer Map oder Set
  * `provider` - Zugriff auf einen nicht-standard Provider
  * `lifecycle` - Lebenszyklus der Resource

## Aufgabe

* Definiere eine lokale Variable für Deinen RACF-user.
* Erstellen von vier Containern mittels `count`
* Hochladen der Beispieldatei mittels `for_each`<br/>
  Dateien sollen erst hochgeladen werden, wenn die Container erstellt worden sind.<br/>
  Hinweis: Nutzer eine lokale Variable (Liste) für die vier Container und Blob-Namen.
* Hinzufügen eines Tags `contact`
* Ignorieren von Änderungen an den Tags des Storage Accounts

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
  racf = ...

  blobs = [
    ...
  ]
}

data "azurerm_resource_group" "rg" {
  name = "tf-training-${...}-rg"
}

resource "azurerm_storage_account" "strg" {
  name                = "tftgutt02strg"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "container" {
  count = ...

  name                  = "data-${...}"
  storage_account_name  = azurerm_storage_account.strg.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob" {
  for_each = {
    for ...
  }

  name                   = each....
  storage_account_name   = azurerm_storage_account.strg.name
  storage_container_name = each....
  type                   = "Block"
  source                 = "./data/hello.txt"

  depends_on = [
    azurerm_storage_container.container
  ]
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

* [Resources](https://www.terraform.io/docs/language/resources/index.html)
* [The lifecycle Meta-Argument](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
