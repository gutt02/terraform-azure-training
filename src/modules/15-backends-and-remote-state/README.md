# Backends and Remote State

* Azure Storage Account zur Speicherung der State-Files
* Zugriff über die Backend-Konfiguration beim `terraform init` Kommando

## Beispiel

Umgebungsvariablen
```powershell
# Azure CLI must be installed
# terraform.exe must be in the PATH

$ENV:ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
$ENV:ARM_CLIENT_SECRET=""
$ENV:ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
$ENV:ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"

$ENV:TF_VAR_client_secret=$ENV:ARM_CLIENT_SECRET

$ENV:TF_STATE_ENV="asy-cap-tf"
$ENV:TF_STATE_STORAGE_ACCOUNT_NAME="asycaptfstrgtf"
$ENV:TF_STATE_STORAGE_ACCOUNT_ACCESS_KEY=""
$ENV:TF_STATE_CONTAINER_NAME="statefiles"
$ENV:TF_STATE_KEY="$ENV:TF_STATE_ENV.tfstate"

$ENV:TF_CLI_ARGS_init="-backend-config=storage_account_name=$ENV:TF_STATE_STORAGE_ACCOUNT_NAME"
$ENV:TF_CLI_ARGS_init="$ENV:TF_CLI_ARGS_init -backend-config=access_key=$ENV:TF_STATE_STORAGE_ACCOUNT_ACCESS_KEY"
$ENV:TF_CLI_ARGS_init="$ENV:TF_CLI_ARGS_init -backend-config=container_name=$ENV:TF_STATE_CONTAINER_NAME"
$ENV:TF_CLI_ARGS_init="$ENV:TF_CLI_ARGS_init -backend-config=key=$ENV:TF_STATE_KEY"

$ENV:TF_CLI_ARGS_plan="-var-file=.\\environments\\$ENV:TF_STATE_ENV.tfvars"
$ENV:TF_CLI_ARGS_apply="-var-file=.\\environments\\$ENV:TF_STATE_ENV.tfvars"
$ENV:TF_CLI_ARGS_destroy="-var-file=.\\environments\\$ENV:TF_STATE_ENV.tfvars"

terraform init
terraform plan
terraform apply
```

`main.tf`
```hcl
terraform {
  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 3.42.0"

    }
  }
}

provider "azurerm" {
  features {}
}
```

`azure-pipelines.yml`
```yaml
variables:
  - group: TF-PoC-Variables
  - name: terraform-plan-file
    value: 'terraform.tfplan'

trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - bash: |
      terraform init \
        -backend-config=storage_account_name=${TF_STATE_STORAGE_ACCOUNT_NAME} \
        -backend-config=access_key=${TF_STATE_STORAGE_ACCOUNT_ACCESS_KEY} \
        -backend-config=container_name=${TF_STATE_CONTAINER_NAME} \
        -backend-config=key=${TF_STATE_KEY}
    displayName: 'terraform init'
    env:
      ARM_CLIENT_ID:                        $(arm_client_id)
      ARM_CLIENT_SECRET:                    $(arm_client_secret)
      ARM_SUBSCRIPTION_ID:                  $(arm_subscription_id)
      ARM_TENANT_ID:                        $(arm_tenant_id)
      TF_STATE_STORAGE_ACCOUNT_NAME:        'asycaptfstrgtf'
      TF_STATE_STORAGE_ACCOUNT_ACCESS_KEY:  $(storage_account_access_key)
      TF_STATE_CONTAINER_NAME:              'statefiles'
      TF_STATE_KEY:                         'asy-poc-tf.tfstate'
    workingDirectory: './terraform'

  - bash: |
      terraform plan \
        --input=false \
        --var-file=./environments/asy-poc-tf.tfvars \
        --out=${TF_STATE_TERRAFORM_PLAN_FILE}
    displayName: 'terraform plan'
    env:
      ARM_CLIENT_ID:                        $(arm_client_id)
      ARM_CLIENT_SECRET:                    $(arm_client_secret)
      ARM_SUBSCRIPTION_ID:                  $(arm_subscription_id)
      ARM_TENANT_ID:                        $(arm_tenant_id)
      TF_STATE_TERRAFORM_PLAN_FILE:         $(terraform-plan-file)
      TF_VAR_client_secret:                 $(arm_client_secret)
    workingDirectory: './terraform'
```

## Links
