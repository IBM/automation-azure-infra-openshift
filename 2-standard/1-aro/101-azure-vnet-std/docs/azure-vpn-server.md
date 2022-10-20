# Azure VPN Server

## Module overview

Module creates an Azure VPN Server. It includes the following resources:
- read local public key file
- Azure VM creation via module with custom bootstrap script for VPN server
- creation and application of VPN server configuration
- creation and download of VPN client connection file

### Software dependencies

- terraform >= 1.2.6

### Terraform providers

- Azure provider >= 3.0.0

### Module dependencies

This modules makes use of the output from other modules:
- Azure Resource Group - github.com/cloud-native-toolkit/terraform-azure-resource-group
- Azure VNet - github.com/cloud-native-toolkit/terraform-azure-vnet
- Azure Subnets - github.com/cloud-native-toolkit/terraform-azure-subnets
- Azure SSH Key - github.com/cloud-native-toolkit/teraform-azure-ssh-key

## Example Usage

```hcl-terraform
locals {
  name_prefix     = "myexample"
  region          = "eastus"
  vnet_cidr       = "10.0.0.0/18"
  subnet_cidrs    = cidrsubnets(local.vnet_cidr, 2, 2)
  ingress_cidr    = local.subnet_cidrs[0]
  internal_cidr   = local.subnet_cidrs[1]
}

module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group?ref=v1.1.1"

  resource_group_name = "${local.name_prefix}-rg"
  region              = local.region
}

module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet?ref=v1.1.3"

  name_prefix         = local.name_prefix
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  address_prefixes    = [local.vnet_cidr]
}

module "ingress-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.7"

  label               = "ingress"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = [local.ingress_cidr]
  acl_rules           = []
}

module "internal-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.7"

  label               = "internal"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  vnet_name           = module.vnet.name
  ipv4_cidr_blocks    = [local.internal_cidr]
  acl_rules           = []
}

module "nsg" {
    source = "github.com/cloud-native-toolkit/terraform-azure-nsg?ref=v1.0.5"


    name_prefix           = local.name_prefix
    resource_group_name   = module.resource_group.name
    region                = module.resource_group.region
    virtual_network_name  = module.vnet.name
    subnet_ids            = [module.ingress-subnet.id]
    acl_rules = [{
          name                = "ssh-inbound"   // Required for VPN configuration
          priority            = "102"
          access              = "Allow"
          protocol            = "Tcp"
          direction           = "Inbound"
          source_addr         = "*"
          destination_addr    = "*"
          source_ports        = "*"
          destination_ports   = "22"
        },{
          name                = "vpn-inbound-tcp"
          priority            = "103"
          access              = "Allow"
          protocol            = "Tcp"
          direction           = "Inbound"
          source_addr         = "*"
          destination_addr    = "*"
          source_ports        = "*"
          destination_ports   = "443"
        },{
          name                = "vpn-inbound-udp"
          priority            = "104"
          access              = "Allow"
          protocol            = "Udp"
          direction           = "Inbound"
          source_addr         = "*"
          destination_addr    = "*"
          source_ports        = "*"
          destination_ports   = "1194"
        }
    ]
}

module "route-table" {
  source = "github.com/cloud-native-toolkit/terraform-azure-rtb?ref=v1.0.0"

  name_prefix           = local.name_prefix
  resource_group_name   = module.resource_group.name
  region                = module.resource_group.region
  subnet_ids            = [module.ingress-subnet.id, module.internal-subnet.id]

  routes = [{
    name                    = "internal-route"
    address_prefix          = local.vnet_cidr
    next_hop_type           = "VnetLocal"
    next_hop_in_ip_address  = ""
  }]
}

module "ssh-keys" {
  source = "github.com/cloud-native-toolkit/terraform-azure-ssh-key?ref=v1.0.6"

  key_name            = "${local.name_prefix}-key"
  resource_group_name = module.resource_group.name
  region              = module.resource_group.region
  store_path          = "${path.cwd}/.ssh"
}

module "vpn-server" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpn-server"
  
  name_prefix             = "${local.name_prefix}-vpn"
  resource_group_name     = module.resource_group.name
  virtual_network_name    = module.vnet.name
  subnet_id               = module.ingress-subnet.id
  pub_ssh_key_file        = module.ssh-keys.pub_key_file
  private_key_file        = module.ssh-keys.private_key_file
  private_network_cidrs   = [local.vnet_cidr]
}
```
## Variables

### Inputs

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| resource_group_name | Mandatory |  | The resource group to which to associate the VPN Server  |
| virtual_network_name | Mandatory |  | The virtual network to which to associate the VPN Server  |
| subnet_id | Mandatory | | The id of the subnet to which to associate the VPN Server| 
| pub_ssh_key_file | Mandatory | | Path to the public SSH key for VPN Server access. |
| private_key_file | Mandatory | | Path to the private SSH key for VPN Server access. |
| private_network_cidrs | Mandatory | | List of CIDRs in the private network reachable via the VPN server. |
| private_dns | Optional | ["168.63.129.16"] | List of private DNS servers. |
| name_prefix | Optional | open-vpn | Name to prefix resources created |
| client_network | Optional | 172.27.224.0 | Network address for VPN clients (default = \"172.27.224.0\") |
| client_network_bits | Optional | 24 | Number of netmask bits for the VPN client network (default = \"24\") |
| private_ip_address_allocation_type | Optional | Dynamic | The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\") |
| admin_username | Optional | azureuser | Username for the admin user (default = \"azureuser\") |
| bootstrap_script | Mandatory | | Path to file with the bootstrap script (default = \"./template/user-data.sh\") |
| vm_size | Optional | Standard_F2 | This is the size of Virtual Machine (defualt = \"Standard_F2\") |
| storage_type | Optional | Standard_LRS | Storage account type |
| vm_public_ip_sku | Optional | Standard | Public IP SKU Size (default = \"Standard\" |
| vm_public_ip_allocation_method | Optional | Static | The Azure subnet Public ip address alocation type - Dynamic or Static (default = \"Static\" |

### Outputs

The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The Id of the deployed vpn server |
| vm_public_ip | The address of the public IP if created |
| vm_public_fqdn | The FQDN of the public IP if created |
| vm_private_ip | The address of the VM on the supplied subnet |
| admin_username | The name of the administrator username |
| client_config_file | VPN server client configuration file to connect vpn server |

