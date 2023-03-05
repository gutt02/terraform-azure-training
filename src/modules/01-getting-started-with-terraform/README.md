# Getting Started with Terraform

## Aufgabe

* Resourcegroup im Portal erstellen
* Storage account mit Terraform erstellen
  * Provider
  * Erstellen eines Storage Accounts mit Terraform
  * Anmelden in Azure
    * `az login <firstname.lastname>@bertelsmann.de`
  * Subscription auswählen 10f01219-0d09-4815-9704-64ef79110325
    * `az account set --subscription 10f01219-0d09-4815-9704-64ef79110325`
    * `az account show`
<ul><ul><ul>

```json
{
  "environmentName": "AzureCloud",
  "homeTenantId": "00000000-0000-0000-0000-000000000000",
  "id": "10f01219-0d09-4815-9704-64ef79110325",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Visual Studio Enterprise-Abonnement",
  "state": "Enabled",
  "tenantId": "00000000-0000-0000-0000-000000000000",
  "user": {
    "name": "mysvc_GUTT02@bert.group",
    "type": "user"
  }
}
```
</ul></ul></ul>

  * Terraform ausführen
    * `terraform --version`
    * `terraform init`
    * `terraform plan`
    * `terraform apply`
    * `terraform destroy`


```hcl
resource "azurerm_resource_group" "rg" {
  name     = "CAP6_GUTT02"
  location = "westeurope"
}
```

## Aufgabe

* Erstelle einen Storage Account

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

resource "..." "..." {
  name                = "..."
  resource_group_name = "..."
  location            = "..."

  ...
}
```

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
