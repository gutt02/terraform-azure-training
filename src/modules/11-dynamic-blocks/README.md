# Dynamic Blocks

```hcl
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace
resource "azurerm_eventhub_namespace" "this" {
  name                = "${var.project.customer}-${var.project.name}-${var.project.environment}-evhns"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = var.eventhub_namespace.sku
  capacity            = var.eventhub_namespace.capacity

  identity {
    type = "SystemAssigned"
  }

  dynamic "network_rulesets" {
    for_each = var.hub_subnet_gateway_id != null ? [var.hub_subnet_gateway_id] : []

    content {
      default_action                 = "Deny"
      public_network_access_enabled  = true
      trusted_service_access_enabled = true

      virtual_network_rule {
        subnet_id                                       = network_rulesets.value
        ignore_missing_virtual_network_service_endpoint = true
      }
    }
  }
}
```

## Aufgabe

* Erstelle einen zweiten Storage Account in der Resourcengruppe.
* Aktiviere alle Log Kategorien für den ersten Storage Account mittels eines Dynamischen Blocks.
* Nutze als Ziel für das Logging den zweiten Storage Account.
* Hinweis: Die `target_resource_id` muss um den Wert `/blobServices/default` erweitert werden.

## Links

[azurerm_monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)
