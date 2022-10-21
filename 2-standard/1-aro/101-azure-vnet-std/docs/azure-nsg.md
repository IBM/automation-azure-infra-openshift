# Azure Network Security Group

## Module Overview

Module creates a network security group (NSG) on Azure with provided rules and associates with provided subnets. It includes the following resources:
- azurerm_network_security_group
- azurerm_subnet_network_security_group_association

### Software dependencies

This module has no dependencies on software components.

### Command line tools

- terraform >= 1.2.6

### Module dependencies

- cloud-native-toolkit/terraform-azure-resource-group
- cloud-native-toolkit/terraform-azure-vnet
- cloud-native-toolkit/terraform-azure-subnets (optional if associating NSG with one or more subnets)

## Example Usage

```hcl-terraform
module "nsg" {
  source = "github.com/cloud-native-toolkit/terraform-azure-nsg"

  name_prefix = "example"
  resource_group_name = module.resource_group.name
  region = module.resource_group.region
  virtual_network_name = module.vnet.name
  subnets = [module.subnets.name[0], module.subnets.name[1]]
  acl_rules = [{
      name                = "ssh-inbound"
      priority            = "101"
      access              = "Allow"
      protocol            = "Tcp"
      direction           = "Inbound"
      source_addr         = "*"
      destination_addr    = "*"
      source_ports        = "*"
      destination_ports   = "22"
      }
  ]  
}
```

## Input Variables

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory | "" | The resource group into which to deploy the NSG |
| region | Mandatory | "" | Region into which to deploy the NSG |
| virtual_network_name | Mandatory | "" | The VNet into which to deploy the NSG |
| name_prefix | Optional | "" | The prefix for the NSG name (module will append "-nsg" to this variable)  |
| name | Optional | "" | The full name for the NSG. One of name or name_prefix must be specified.  |
| subnet_ids | Optional | [] | List of subnet ids in the VNet to which to associate the NSG when created |
| acl_rules | Optional | [] | List of ACL rules to apply (refer to variables.tf for details) |

## Output Variables

This module has the following output variables:
| Variable | Description |
| -------------------------------- | ----------------------------------------------------------------------------- |
| id  | The Azure identification string of the created NSG  |
| name | The name of the created NSG |