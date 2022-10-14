# Azure Red Hat OpenShift module

## Module Overview

Module creates an Azure RedHat OpenShift (ARO) cluster. It includes the following resources:
- terraform-util-clis (to setup CLI utils for build)
- random_domain
- terraform-azure-resource-group (to create a resource group for the ARO cluster)
- null_resource_aro (creates and destroys the cluster)

### Software dependencies

- terraform CLI >= 1.2.6
- Azure CLI (az) >= 2.39.0

### Terraform providers

- Terraform >= 0.15.0
- Azure provider >= 3.0.0

### Module dependencies

This module makes use of the output from other modules:
- Azure Resource Group = github.com/cloud-native-toolkit/terraform-azure-resource-group
- Azure VNet - github.com/cloud-native-toolkit/terraform-azure-vnet
- Azure Subnets - github.com/cloud-native-toolkit/terraform-azure-subnets

## Prerequisites

### Option 1 - Use a service principal 

The service principal needs the following roles assigned
- In the active directory, application and user administrator permissions

  - User Administrator
    1. From the Azure Active Directory page, go to Roles and administrators. 
    1. Find user administrators
    1. Add assignment

  - Application administrator
    1. Select the created service principal and assign role
    1. Find Application administrator
    1. Add assignment
    1. Select the created service principal and assign role

- In the subscription, application and user administrator
  - User Administrator
    1. Go to the subscription page.
    1. Select Access Control (IAM)
    1. Review Role assignments
    1. Add role (+ Add)
    1. Select "Add role assignment"
    1. Search for User Access Administrator
    1. Go to Members
    1. Select Members (+ Select Members)
    1. Choose the service principal
    1. Review and assign

  - Application Administrator
    1. Go to the subscription page.
    1. Select Access Control (IAM)
    1. Review Role assignments
    1. Add role (+ Add)
    1. Select "Add role assignment"
    1. Search for Application Administrator
    1. Go to Members
    1. Select Members (+ Select Members)
    1. Choose the service principal
    1. Review and assign

### Option 2 - Login with your own user

Functionality to support using your own user will be provided in a future release.

## Example Usage

```hcl-terraform
module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "mytest-rg"
  region              = var.region
}

module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet"

  name_prefix         = "mytest"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  address_prefixes    = ["10.0.0.0/18"]
}

module "worker-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  label               = "worker"
  ipv4_cidr_blocks    = ["10.0.0.0/24"]
  acl_rules           = []
  service_endpoints   = ["Microsoft.ContainerRegistry","Microsoft.Storage"]
}

module "master-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  label               = "master"
  ipv4_cidr_blocks    = ["10.0.1.0/24"]
  acl_rules           = []
  service_endpoints   = ["Microsoft.ContainerRegistry","Microsoft.Storage"]
}

module "aro" {
  source               = "github.com/cloud-native-toolkit/terraform-azure-aro"

  name_prefix           = "mytest"
  
  subscription_id       = var.azure_subscription_id
  tenant_id             = var.azure_tenant_id
  client_id             = var.service_principal_id
  client_secret         = var.service_principal_secret

  resource_group_name   = module.resource_group.name
  region                = module.resource_group.region
  vnet_name             = module.vnet.name
  master_subnet_id      = module.master-subnet.id
  worker_subent_id      = module.worker-subnet.id
}
```

## Variables

### Inputs

### Inputs

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory |  | The resource group of the network (VNet and subnet) components. A new resource group will be created for the cluster.  |
| region | | Manadatory | The Azure region/location where the cluster is to be deployed |
| vnet_name | | Mandatory | The Azure VNet on which to create the cluster |
| worker_subnet_id | | Mandatory | The id of the Azure subnet to attach the worker/compute nodes to |
| master_subnet_id | | Mandatory | The id of the Azure subnet to attach the master/controller nodes to |
| name_prefix | Mandatory | | Name to prefix the created resources |
| subscription_id | Mandatory | | Azure subscription id where the cluster will be installed |
| tenant_id | Mandatory | | Azure tenant id where the cluster will be installed |
| client_id | Mandatory | | The id of the service principal to be used for the cluster creation and ongoing management |
| client_secret | Mandatory | | The secret of the service principal to be used for the cluster creation and ongoing management |
| name | "" | Optional | The name to give to the cluster. If left blank, the name will be generated from the name_prefix |
| name_prefix | "" | Optional | The prefix for the cluster name. If left blank, the network resource group name will be used to derive the cluster name | 
| master_flavor | Standard_D8s_v3 | Optional | The VM size for the master/controller nodes |
| flavor | Standard_D4s_v3 | Optional | The VM size for the worker/compute nodes |
| _count | 3 | Optional | The number of worker/compute nodes to be created (min 2) |
| provision | true | Optional | Flag to determine whether to provison the cluster. If false, an existing cluster will be queried |
| disable_public_endpoint | false | Optional | If set true, no public facing endpoints will be provisioned (used for private VNet deployments) |
| pull_secret | "" | Optional | A Red Hat pull secret used to access a Red Hat account. If left blank and no pull secret file is provided, cluster will still deploy, but additional content will not be available |
| pull_secret_file | "" | Optional | Path to a file containing a Red Hat pull secret used to access a Red Hat account. If left blank and no pull secret is provided, cluster will still deploy, but additional content will not be available |
| label | cluster | Optional | Suffix to be added to the name_prefix to derive the cluster name if no name is provided |

### Outputs

The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The Id of the cluster |
| name | The name of the cluster |
| resource_group_name | The resource group containing the cluster (as opposed to the network resource group) |
| region | The Azure region/location containing the cluster |
| config_file_path | The path to the OpenShift kube config file for the cluster |
| token | The login token for the cluster |
| username | The login username for the cluster |
| password | The login password for the cluster |
| serverURL | The API URL for the cluster |
| platform | Object containing details of the cluster (refer to output.tf for details) |