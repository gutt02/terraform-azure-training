# Modules

```hcl
module "base" {
  source = "./modules/000_base"

  # Project related variables
  client_ips               = var.client_ips
  environment_is_private   = var.environment_is_private
  hub_subnet_gateway_id    = var.hub_subnet_gateway_id
  hub_vnet_id              = var.hub_vnet_id
  local_deployment_enabled = var.local_deployment_enabled
  location                 = var.location
  on_premises_networks     = var.on_premises_networks
  private_dns_zone_id      = var.private_dns_zone_id
  private_dns_zones        = var.private_dns_zones
  project                  = var.project
  role_assignment_enabled  = var.role_assignment_enabled
  security_groups          = var.security_groups
  tags                     = var.tags
  virtual_network          = var.virtual_network

  # Module related variables
  aacc            = var.aacc
  app_insights    = var.app_insights
  key_vault       = var.key_vault
  log_analytics   = var.log_analytics
  module_enabled  = false
  resource_groups = var.resource_groups
  strg_log        = var.strg_log
}
```

## Aufgabe

* Erstelle ein Module (Unterverzeichnis) für den Storage Account
* Definiere Variable für die Resourcegruppe im Modul
* Referenziere die Resourcengruppe im Root-Modul
* Übergebe die Resourcengruppe an das Modul
* Erstelle den Storage Account

## Links

* [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
* [Data Source: azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
* [azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container)
* [Define Input Variables](https://learn.hashicorp.com/tutorials/terraform/azure-variables)
* [Input Variables](https://www.terraform.io/docs/language/values/variables.html)
* [Local Values](https://www.terraform.io/docs/language/values/locals.html)
* [Data Sources](https://www.terraform.io/docs/language/data-sources/index.html)
* [Modules](https://developer.hashicorp.com/terraform/language/modules/develop)
