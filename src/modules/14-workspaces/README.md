# Workspaces

Jede Terraform-Konfiguration hat ein zugehöriges Backend, das definiert, wie Terraform Operationen ausführt und wo Terraform persistente Daten, wie den Status, speichert.

Die persistenten Daten, die im Backend gespeichert werden, gehören zu einem Workspace. Das Backend hat zunächst nur einen Workspace, der einen Terraform-Status enthält, der mit dieser Konfiguration verbunden ist. Einige Backends unterstützen mehrere benannte Workspaces, so dass mehrere Zustände mit einer einzigen Konfiguration verknüpft werden können. Die Konfiguration hat immer noch nur ein Backend, aber Sie können mehrere unterschiedliche Instanzen dieser Konfiguration einsetzen, ohne ein neues Backend zu konfigurieren oder die Authentifizierungsdaten zu ändern.

> Wichtig: Arbeitsbereiche eignen sich nicht für die Systemdekomposition oder für Einsätze, die separate Anmeldedaten und Zugriffskontrollen erfordern. Siehe Use Cases in der Terraform CLI Dokumentation für Details und empfohlene Alternativen.

## Aufgabe

* Erstelle zwei Workspaces dev und test
* Passe das main.tf Skript so an, dass im Namen der Resourcegruppe und des Azure Storage Accounts der Workspace genutzt wird.
* Erstelle für jeden Workspace dev und test die Resourcengruppe und den Storage Account.

## Links

[Workspaces](https://developer.hashicorp.com/terraform/language/state/workspaces)