# Provisioners

* Nicht alles geht mit Terraform
* Provisioners bieten die Möglichkeit lokal oder remote Skripte auszuführen oder Resource außerhalb von Terraform zu ändern.

```hcl
resource "null_resource" "create_sql_user_mssql_data_factory" {
  for_each = {
    for o in local.mssql_database : lower(replace(o.key, " ", "_")) => o if var.module_enabled && var.data_factory.is_enabled && !var.environment_is_private || var.local_deployment_enabled
  }

  provisioner "local-exec" {
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
    command     = "sqlcmd -S ${each.value.mssql_server.fully_qualified_domain_name} -G -U ${var.sql_aad_admin_login} -P ${var.sql_aad_admin_password} -d ${each.value.mssql_database.name} -Q 'CREATE USER [${azurerm_data_factory.data_factory[0].name}] FROM EXTERNAL PROVIDER WITH DEFAULT_SCHEMA = dbo;'"
  }

  depends_on = [
    time_sleep.delay_create_sql_user_mssql_data_factory
  ]
}
```

```hcl
# https://learn.microsoft.com/en-us/cli/azure/vm/run-command?view=azure-cli-latest#az-vm-run-command-invoke
# https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
resource "null_resource" "mount_data_disk" {
  provisioner "local-exec" {
    command = "az vm run-command invoke --command-id RunShellScript --name ${azurerm_linux_virtual_machine.this.name} -g ${azurerm_resource_group.this.name} --scripts @scripts/add_data_disk.sh"
  }

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.this
  ]
}
```

## Aufgabe

* Erstellen einer Tabelle im Storage Account per Azure CLI

## Links

[az storage table create](https://learn.microsoft.com/de-de/cli/azure/storage/table?view=azure-cli-latest#az-storage-table-create)

