# Azure Resource Group

## Module overview

### Description

This module provisions a resource group in Azure.

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - https://www.terraform.io/docs/language/modules/develop/providers.html. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly.

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15

#### Terraform providers

- Azure provider >= 2.91.0

### Module dependencies

None

### Example usage

```hcl-terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.91.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = var.resource_group_name
  region              = var.region
}
```

