# Expressions

* Zuweisung unterschiedlicher Tags an den Storage Account unter Nutzung von Expressions

## Beispiel

`main.tf`
```javascript
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

locals {
  racf = "gutt02"
}

data "azurerm_resource_group" "rg" {
  name = "${local.racf}-cap-msdn-rg"
}

resource "azurerm_storage_account" "strg" {
  name                = "tft${local.racf}strg"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    racf = "RACF: ${local.racf}"

    is_racf = local.racf == "gutt02" ? "true" : "false"

    eot = <<EOT
      Test EOT
    EOT

    eot2 = <<-EOT
      Test EOT w/o indentation.
    EOT

    testing_if = "Hello, %{ if local.racf != "" }${local.racf}%{ else }unknown%{ endif }!"
  }

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

resource "azurerm_storage_container" "containers" {
  count = 4

  name = "data-${count.index}"
  storage_account_name = azurerm_storage_account.strg.name
  container_access_type = "private"
}

locals {
  blobs = [
    {
      blob_name = "hello_0.txt",
      container_name = "data-0"
    },
    {
      container_name = "data-1"
      blob_name = "hello_1.txt",
    },
    {
      blob_name = "hello_2.txt",
      container_name = "data-2"
    },
    {
      blob_name = "hello_3.txt",
      container_name = "data-3"
    }
  ]
}

resource "azurerm_storage_blob" "blobs" {
  for_each = {for blob in local.blobs: blob.blob_name => blob}

  name                   = each.value.blob_name
  storage_account_name   = azurerm_storage_account.strg.name
  storage_container_name = each.value.container_name
  type                   = "Block"
  source                 = "./data/hello.txt"

  depends_on = [
    azurerm_storage_container.containers
  ]
}
```

## Links
