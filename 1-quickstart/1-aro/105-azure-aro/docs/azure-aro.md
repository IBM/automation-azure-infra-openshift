# Azure Red Hat OpenShift module

## Module Overview

Module creates an Azure RedHat OpenShift (ARO) cluster. It includes the following resources:
- terraform-util-clis - to setup CLI utils for build
- terraform-ocp-login - to login to the cluster once it is built
- random_domain - generates a random domain name
- null_resource az_login - to login to the az cli with the supplied credentials, or use existing login
- external aro_rp - to obtain OpenShift resource provider details
- null_resource service_principal - to create and destroy a service principal for cluster to use to call Azure API
- azurerm_key_vault - if a key_vault_id is not provided, this will create a new key vault for the service principal details
- azurerm_key_vault_secret - to store the service principal details
- azurerm_role_assignment - assigns required roles to service principal and resource provider
- azapi_resource - CRUD for the ARO cluster
- external aro - obtains details of the created cluster
- time_sleep - a delay to allow the cluster to settle

### Software dependencies

- terraform CLI >= 1.2.6 
- Azure CLI (az) >= 2.42.0 (must be in the path environment variable)

### Terraform providers

- Terraform >= 0.15.0
- Azure provider (azurerm) >= 3.3.0
- Azure API provider (azapi) >= 1.0.0

### Module dependencies

This module makes use of the output from other modules:
- Azure Resource Group = github.com/cloud-native-toolkit/terraform-azure-resource-group
- Azure VNet - github.com/cloud-native-toolkit/terraform-azure-vnet
- Azure Subnets - github.com/cloud-native-toolkit/terraform-azure-subnets

## Prerequisites

### Common

Ensure that the subscription has the `Microsoft.RedHatOpenShift` provider namespace registerd. 
To do so:
  ```
  $ az provider register --namespace "Microsoft.RedHatOpenShift"
  ```

### Azure Login Option 1 - Use a service principal 

Use this option with automated execution. The service principal needs the following roles assigned
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

1. Export the service principal details are environment variables.

  ```
  $ export TF_VAR_subscription_id=<subscription_id>
  $ export TF_VAR_tenant_id=<tenant_id>
  $ export TF_VAR_client_id=<service_principal_app_id>
  $ export TF_VAR_client_secret=<service_principal_secret>
  ```

1. Set the variables in the provider block to use those credentials
  ```hcl-terraform
  provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
  }
  ```

### Azure Login Option 2 - Use your Azure user id

Use this option if running from your terminal. Uses your Azure user. 
***Note that your Azure user must have contributor and user access administrator rights to the subscription***
1. Login to the az cli from within the container before proceeding with terraform actions.  
  ```
  $ az login
  ```
1. If you have more than one subscription, set the relevant subscription to be used.
  ```
  $ az account set --subscription="<SUBSCRIPTION_ID>"
  ```
  where <SUBSCRIPTION_ID> is the id of the subscription to be utilized.

1. Do not include the login details in the provider.tf file in terraform
  ```hcl-terraform
  provider "azurerm" {
    features {}
  }
  ```

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

  resource_group_name   = module.resource_group.name
  vnet_name             = module.vnet.name
  master_subnet_id      = module.master-subnet.id
  worker_subnet_id      = module.worker-subnet.id

  encrypt               = true
}
```

## Variables

### Inputs

This module has the following input variables:
| Variable | Default Value | Mandatory / Optional | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | | Mandatory  | The resource group of the network (VNet and subnet) components. A new resource group will be created for the cluster. The location of the cluster will be the same as this resource group.  |
| vnet_name | | Mandatory | The Azure VNet on which to create the cluster |
| worker_subnet_id | | Mandatory | The id of the Azure subnet to attach the worker/compute nodes to |
| master_subnet_id | | Mandatory | The id of the Azure subnet to attach the master/controller nodes to |
| name_prefix | | Mandatory | Name to prefix the created resources |
| client_secret | "" | Optional  | The secret of the service principal to be used for the cluster creation and ongoing management. Provide if using a service principal for azurerm login. |
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
| key_vault_id | "" | Optional | Existing key vault id to use (will create a new one if not provided) |
| encrypt | false | Optional | Flag to encrypt the master and worker nodes with server side encryption |
| pod_cidr | 10.128.0.0/14 | Optional | CIDR for the internal pod subnet |
| service_cidr | 172.30.0.0/16 | Optional | CIDR for the internal services subnet |
| fips | false | Optional | Flag to use FIPS validated modules |
| tags | {} | Optional | List of tags to be included as name value key pairs |

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
| console_url | The URL of the web console for the cluster |
| platform | Object containing details of the cluster (refer to output.tf for details) |