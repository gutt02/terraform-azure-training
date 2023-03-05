# What is Terraform?

## Beschreibung

* Bereitstellung von Services in der Cloud, gerne auch IaC genannt, sollte weitestgehend automatisiert erfolgen.
* Hier wollen wir ein paar Basisinformationen für den Start vermitteln.
* Innerhalb der Arvato Systems hat sich Terraform als Tool zur Bereitstellung der entsprechenden Infrastruktur etabliert.
* Ein wesentlicher Vorteil von Terraform ist, dass die drei großen Cloud Provider Azure (Microsoft), AWS (Amazon) und GCP (Google) unterstützt werden.
* Für größere Projekte werden die Services auch oft durch die Kollegen aus dem Rechenzentrum bereitgestellt.
* Ist zum Start des Projekts abzusehen, dass die spätere Betreuung durch Arvato Systems erfolgen wird, dann sprecht zeitnah mit den Kollegen aus dem Team von Jannis Lünne.

## Was ist Terraform?

* Software-Toolkit für die Verwaltung und automatisierte Erstellung von Infrastruktur.
* Statt Infrastruktur-Ressourcen, bspw. VMs, manuell anzulegen, wird dies über spezielle Sprache beschrieben.
* Zudem können darüber Zusammenhänge zwischen Ressourcen abgebildet und ausgenutzt werden, sodass diese in der notwendigen Reihenfolge angelegt werden und Informationen dieser für andere Ressourcen genutzt werden können.

## Wie funktioniert Terraform?

* **3 essentielle Komponenten**
  * **Terraform-Core**
    * Software-Basis
    * Dient zur Umsetzung der Konfiguration in tatsächliche Ressourcen
    * Erstellt Resource-Graph und verwaltet darüber Abhängigkeiten zwischen Ressourcen
  * **Terraform-Config**
    * Beschreibt die notwendigen Ressourcen, bspw. VMs, Netzwerke, Cloud-Services
    * Beziehungen können definiert werden. Bsp.: VM-01 ist Teil von Subnetz-02 im Netzwerk-01
    * Link zur Beschreibung der Syntax
  * **Provider**
    * Stellen Anbindung an ein konkretes (Cloud-)System her. Bspw. Azure, AWS, GCP, OpenStack, VMWare, ...
    * Neben Cloud-Plattform werden auch "high-level" Anbindungen unterstützt, bspw. die Konfiguration eines Kubernetes (Namespaces, pods etc. anlegen)
* **Terraform Workflow**
  * **Write**
    * Beschreibung der Infrastruktur als Code (Abk. IaC)
    * Beschreibung der Ressourcen und ihrer Parameter in *.tf Dateien (mehrere Dateien möglich)
  * **Plan**
    * Validierung der Konfigurationsdateien
    * Abgleich der aktuell ausgerollten Infrastruktur und der aktuellen Version der Konfiguration
    * Erstellt einen Plan, welche Ressourcen erstellt und wie bestehende angepasst werden müssen, damit sie der Konfiguration entsprechen.
  * **Apply**
    * Ausführung/Umsetzung des zuvor erstellten Plans
    * Dabei werden bestehende Ressourcen angepasst, neue erstellt, alte abgebaut, je nachdem der Plan ergeben hat
    * Das Ergebnis wird in Status-Dateien (Terraform State) abgelegt: Dadurch "weiß" Terraform welche Ressourcen es angelegt hat (eindeutig über ID identifizierbar; Namen im allgemein nicht eindeutig)
* **Arbeit im Team**
  * Verwaltung der Konfigurationsdateien in Repository
    * Etablierter Workflow für gemeinsame Bearbeitung von Dateien
    * Gewohnte Features: Code-Reviews, Pull-Requests, Branching, ...
  * Zentrale Ablage des Terraform State
    * Üblich sind Cloud-Speicher wie Azure Storage Accounts, AWS S3, ... (Liste )
    * Zusätzlich unterstützen viele dieser Remote-Backends Locks sodass Änderungen durch mehrere Teammitglieder nicht versehentlich gleichzeitig angewendet werden wodurch Konflikte vermieden werden.

## Vorteile / Nachteile

* **Vorteile**
  * Hoher Grad an Automatisierung möglich
  * Konfiguration in sich konsistent und Änderungen dokumentiert (da über Konfigurationsanpassungen ausgerollt), daher kein Silo-Wissen.
  * Modularisierung um Wiederverwendung und organisationsweite Pattern zu ermöglichen
  * Durch Unterstützung vieler Cloud-Provider, muss IaC-Sprache nur ein Mal gelernt werden (im Gegensatz zu Cloud-spezifischen Varianten wie ARM)
Sehr kompakte Beschreibung, auch komplexer Ressourcen möglich (um ein vielfaches weniger Code als bei ARM)
* **Nachteile**
  * Neue Sprache muss erlernt werden
  * Fähigkeiten, d.h. Konfigurationsmöglichkeiten von Ressourcen und dessen Attributen ist vom Provider abhängig. Unterstützung für neue Ressourcen muss erst eingebaut werden.
  * Dokumentation je nach Provider manchmal lückenhaft
* **Probleme**
  * Terraform schützt entgegen anderer Configuration-Management-Lösungen wie Powershell DSC nicht automatisch gegen "Configuration Drift".
  * Terraform hat regelmäßig fehlende Features, die die nativen Services der Cloud Provider (bspw. Azure ARM) schon umsetzen können. Das betrifft vor allem neue Features. Hier kann dann bspw. auf ARM Template Deployments via Terraform zurückgegriffen werden oder die Nacharbeiten manuell erledigt werden
  * Terraform führt zu Inkonsistenzen, wenn bspw. eine API einen Timeout zurückgibt, die Ressource aber trotzdem anlegt. Im Terraform State ist diese Ressource nicht enthalten, in der echten Welt aber schon
  * Terraform hat sehr starke Abhängigkeiten, was insbesondere in echten Multi-Cloud-Szenarien ein Problem werden kann. Beispiel: Deployment eines AKS in Azure, Deployment von DNS Einträgen in CloudFlare, Deployment von Helm Charts in das AKS. Wenn hier nur neue Helm Charts deployt werden sollen und die CloudFlare API nicht erreichbar ist (auch ohne Änderungen), können plötzlich keine Helm Charts mehr deployt werden.

## Installation

* **Software installieren**
  * [Azure CLI](https://docs.microsoft.com/de-de/cli/azure/install-azure-cli)
  * [Terraform by HashiCorp](https://www.terraform.io/downloads.html)
    * Installationsanleitung für Windows:
    * Die _EXE_ entpacken und an einen beliebigen Ort kopieren
    * Bspw. `C:\Program Files\Terraform` (Admin-Rechte nötig) oder alternativ `%USERPROFILE%\Terraform`
    * Den zuvor genutzten Ordner zur PATH-Umgebungsvariable hinzufügen:
      * `[WIN]+R` drücken `rundll32.exe sysdm.cpl,EditEnvironmentVariables` eingeben und mit `[ENTER]` öffnen
      * `Path` aus der unteren Liste Systemvariablen (Admin-Rechte nötig, ansonsten die obere Liste verwenden) heraussuchen und per Doppelklick öffnen
      * Den Pfad hinzufügen und Änderungen mit `[OK]` bestätigen
  * Einen Editor, der Syntax-Highlighting für Terraform/HCL unterstützt, z. B. [Visual Studio Code](https://code.visualstudio.com/)
    * Im Falle von Visual Studio Code wird eine Erweiterung benötigt. Diese kann über den Kommandozeilen-Befehl code `--install-extension hashicorp.terraform` installiert werden.

## Einführung

* Kurze Einführung zu Terraform selbst anschauen
  * (Empfehlenswert) [Video](https://www.terraform.io/intro/index.html) zur Erläuterung wie Terraform arbeitet anschauen
  * (Optional) Idealerweise schaut jeder schon einmal über die Anleitung [Get Started - Azure](https://learn.hashicorp.com/collections/terraform/azure-get-started).

## Links

[Terraform by HashiCorp](https://www.terraform.io/)
