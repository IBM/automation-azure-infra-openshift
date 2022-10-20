# Azure VNet Subnets

## Module overview

### Description

Module that provisions virtual network subnets on Azure, including the following resources:
- subnet
- network security group
- security group subnet association

The number of subnets created is controlled by the number of subnet CIDR's supplied and the provision flag. If the provison flag is set to false (it is true by default), the module will not provision anything and will only read the provided subnet name details (use the subnet_name variable to supply the subnet name).

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - https://www.terraform.io/docs/language/modules/develop/providers.html. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly.

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15

#### Terraform providers

- Azure provider

### Module dependencies

This module makes use of the output from other modules:

- Resource Group - github.com/cloud-native-toolkit/terraform-azure-resource-group
- VNet - github.com/cloud-native-toolkit/terraform-azure-vnet

### Example usage

```hcl-terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

module "subnets" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region = var.region
  vpc_name = module.vpc.name
  ipv4_cidr_blocks = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  acl_rules = [{
    name = "ssh-inbound"
    action = "Allow"
    direction = "Inbound"
    source = "*"
    destination = "*"
    tcp = {
      destination_port_range = "22"
      source_port_range = "*"
    }
  }, {
    name = "internal-only"
    action = "Allow"
    direction = "Inbound"
    source = "10.0.0.0/16"
    destination = "10.0.0.0/24"
    udp = {
      destination_port_range = "1024 - 2048"
      source_port_range = "*"
    }
  }]
}
```

## Input Variables

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory |  | The resource group into which to deploy or query |
| region | Mandatory |  | Region into which to deploy or query |
| vnet_name | Mandatory |  | Name of the VNet into which to deploy or query |
| subnet_name | Optional | "" | Name of an existing subnet to query |
| label | Optional | "" | Label to use in subnet names |
| provision | Optional | true | Flag to provision new resources or query existing if false |
| ipv4_cidr_blocks | Optional | [] | List of CIDRs for subnets to be created |
| acl_rules | Optional | [] | List of rules to create and associate with the subent(s) |
| service_endpoints | Optional | Microsoft.ContainerRegistry | List of service endpoints for the subnet(s)|
| disable_private_link_endpoint_network_policies | Optional | false | Flag to disable private link endpoint network policies in the subnet(s) |
| disable_private_link_service_network_policies | Optional | false | Flag to disable private link service network policies in the subnet(s) |

## Output Variables

This module has the following output variables:
| Variable | Description |
| -------------------------------- | ----------------------------------------------------------------------------- |
| id  | The Azure identification string of the created RTB  |
| name | The name of the subnet if creating only one |
| count | The number of subnets created or queried |
| ids | List of the ids of the created subnets |
| id | Id of the first created subnet |
| names | List of the names of the created subnets |
| subnets | Object list for the created subnets |
| acl_id | Id of the created network security group |
| vnet_name | Name of the VNet where the subnets were provisioned (passthrough) |
| vnet_id | Id of the VNet where the subnets were provisoned |
| cidr_block | The list of CIDRs assigned to the subnets (passthrough) |
