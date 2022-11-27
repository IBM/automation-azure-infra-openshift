variable "resource_group_name" {
  type = string
  description = "The name of the resource group"
}
variable "resource_group_provision" {
  type = bool
  description = "Flag indicating that the resource group should be created"
  default = true
}
variable "resource_group_sync" {
  type = string
  description = "Value used to order the provisioning of the resource group"
  default = ""
}
variable "region" {
  type = string
  description = "The Azure location where the resource group will be provisioned"
}
variable "subscription_id" {
  type = string
  description = "the value of subscription_id"
}
variable "client_id" {
  type = string
  description = "the value of client_id"
}
variable "client_secret" {
  type = string
  description = "the value of client_secret"
}
variable "tenant_id" {
  type = string
  description = "the value of tenant_id"
}
variable "vnet_name" {
  type = string
  description = "The name of the vpc instance"
  default = ""
}
variable "name_prefix" {
  type = string
  description = "The name of the vpc resource"
  default = ""
}
variable "vnet_provision" {
  type = bool
  description = "Flag indicating that the instance should be provisioned. If false then an existing instance will be looked up"
  default = true
}
variable "vnet_address_prefix_count" {
  type = number
  description = "The number of ipv4_cidr_blocks"
  default = 0
}
variable "vnet_address_prefixes" {
  type = string
  description = "List of ipv4 cidr blocks for the address prefixes (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.0.0/20\"]"
}
variable "vnet_base_security_group_name" {
  type = string
  description = "The name of the base security group. If not provided the name will be based on the vpc name"
  default = ""
}
variable "vnet_internal_cidr" {
  type = string
  description = "The cidr range of the internal network"
  default = "10.0.0.0/8"
}
variable "master_subnet_subnet_name" {
  type = string
  description = "The name of the subnet instance"
  default = ""
}
variable "master_subnet_label" {
  type = string
  description = "Label for the subnets created"
  default = "master"
}
variable "master_subnet_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = true
}
variable "master_subnet_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.1.0/24\"]"
}
variable "master_subnet_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
variable "master_subnet_service_endpoints" {
  type = string
  description = "The list of service endpoints for the subnet"
  default = "[\"Microsoft.ContainerRegistry\",\"Microsoft.Storage\"]"
}
variable "master_subnet_disable_private_link_endpoint_network_policies" {
  type = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default = true
}
variable "master_subnet_disable_private_link_service_network_policies" {
  type = bool
  description = "Flag to disable private link service network policies in the subnet."
  default = true
}
variable "worker_subnet_subnet_name" {
  type = string
  description = "The name of the subnet instance"
  default = ""
}
variable "worker_subnet_label" {
  type = string
  description = "Label for the subnets created"
  default = "worker"
}
variable "worker_subnet_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = true
}
variable "worker_subnet_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.2.0/24\"]"
}
variable "worker_subnet_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
variable "worker_subnet_service_endpoints" {
  type = string
  description = "The list of service endpoints for the subnet"
  default = "[\"Microsoft.ContainerRegistry\",\"Microsoft.Storage\"]"
}
variable "worker_subnet_disable_private_link_endpoint_network_policies" {
  type = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default = false
}
variable "worker_subnet_disable_private_link_service_network_policies" {
  type = bool
  description = "Flag to disable private link service network policies in the subnet."
  default = false
}
variable "ingress_subnet_subnet_name" {
  type = string
  description = "The name of the subnet instance"
  default = ""
}
variable "ingress_subnet_label" {
  type = string
  description = "Label for the subnets created"
  default = "ingress"
}
variable "ingress_subnet_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = true
}
variable "ingress_subnet_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.3.0/24\"]"
}
variable "ingress_subnet_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
variable "ingress_subnet_service_endpoints" {
  type = string
  description = "The list of service endpoints for the subnet"
  default = "[\"Microsoft.ContainerRegistry\"]"
}
variable "ingress_subnet_disable_private_link_endpoint_network_policies" {
  type = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default = false
}
variable "ingress_subnet_disable_private_link_service_network_policies" {
  type = bool
  description = "Flag to disable private link service network policies in the subnet."
  default = false
}
variable "nsg_name" {
  type = string
  description = "Name for network security group - replaces name_prefix (default = \"\")"
  default = ""
}
variable "nsg_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[{\"name\":\"ssh-inbound\",\"priority\":\"101\",\"access\":\"Allow\",\"protocol\":\"Tcp\",\"direction\":\"Inbound\",\"source_addr\":\"*\",\"destination_addr\":\"*\",\"source_ports\":\"*\",\"destination_ports\":\"22\"},{\"name\":\"vpn-inbound-tcp\",\"priority\":\"102\",\"access\":\"Allow\",\"protocol\":\"Tcp\",\"direction\":\"Inbound\",\"source_addr\":\"*\",\"destination_addr\":\"*\",\"source_ports\":\"*\",\"destination_ports\":\"443\"},{\"name\":\"vpn-inbound-udp\",\"priority\":\"103\",\"access\":\"Allow\",\"protocol\":\"Udp\",\"direction\":\"Inbound\",\"source_addr\":\"*\",\"destination_addr\":\"*\",\"source_ports\":\"*\",\"destination_ports\":\"1194\"}]"
}
variable "ssh-keys_key_name" {
  type = string
  description = "Name to give to SSH key"
  default = ""
}
variable "ssh-keys_store_path" {
  type = string
  description = "Path to directory in which to store keys (will default to current working directory)"
  default = ""
}
variable "ssh-keys_public_file_permissions" {
  type = string
  description = "Permissions to be set on public key files (default = 0600)"
  default = "0600"
}
variable "ssh-keys_private_file_permissions" {
  type = string
  description = "Permissions to be set on public key files (default = 0400)"
  default = "0400"
}
variable "ssh-keys_store_key_in_vault" {
  type = bool
  description = "Flag to storage the generated or supplied key in the Azure vault"
  default = true
}
variable "ssh-keys_ssh_key" {
  type = string
  description = "Path to existing public key to be used. Will be created if empty. (Default empty string)"
  default = ""
}
variable "ssh-keys_algorithm" {
  type = string
  description = "Algorithim to be utilized if creating a new key (RSA, ECDSA or ED25519, default = RSA)"
  default = "RSA"
}
variable "ssh-keys_rsa_bits" {
  type = number
  description = "Number of bits to use for RSA key (default = 4096)"
  default = 4096
}
variable "ssh-keys_ecdsa_curve" {
  type = string
  description = "ECDSA Curve value to be utilized for ECDSA key (P224, P256, P521, default = P224)"
  default = "P224"
}
variable "ssh-keys_tags" {
  type = map(string)
  description = "Extra tags to be added to the Azure Vault entry (default = none)"
  default = {}
}
variable "vpn-server_private_network_cidrs" {
  type = string
  description = "List of CIDRs in the private network reachable via the VPN server."
  default = "[\"10.0.0.0/20\"]"
}
variable "vpn-server_private_dns" {
  type = string
  description = "List of private DNS servers"
  default = "[\"168.63.129.16\"]"
}
variable "vpn-server_name_prefix" {
  type = string
  description = "Name to prefix resources created"
  default = "open-vpn"
}
variable "vpn-server_client_network" {
  type = string
  description = "Network address for VPN clients (default = \"172.27.224.0\")"
  default = "172.27.224.0"
}
variable "vpn-server_client_network_bits" {
  type = string
  description = "Number of netmask bits for the VPN client network (default = \"24\")"
  default = "24"
}
variable "vpn-server_private_ip_address_allocation_type" {
  type = string
  description = "The Azure subnet private ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default = "Dynamic"
}
variable "vpn-server_admin_username" {
  type = string
  description = "Username for the admin user (default = \"adminuser\")"
  default = "azureuser"
}
variable "vpn-server_bootstrap_script" {
  type = string
  description = "Path to file with the bootstrap script (default = \"./template/user-data.sh\")"
  default = ""
}
variable "vpn-server_vm_size" {
  type = string
  description = "This is the size of Virtual Machine (defualt = \"Standard_F2\")"
  default = "Standard_B1s"
}
variable "vpn-server_storage_type" {
  type = string
  description = "Storage account type (default = \"StandardSSD_LRS\")"
  default = "StandardSSD_LRS"
}
variable "vpn-server_vm_public_ip_sku" {
  type = string
  description = "Public IP SKU Size (default = \"Standard\")"
  default = "Standard"
}
variable "vpn-server_vm_public_ip_allocation_method" {
  type = string
  description = "The Azure subnet Public ip address alocation type - Dynamic or Static (default = \"Dynamic\")"
  default = "Static"
}
