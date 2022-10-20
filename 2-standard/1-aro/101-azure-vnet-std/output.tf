output "resource_group_name" {
  description = "The name of the resource group"
  value = module.resource_group.name
}
output "resource_group_id" {
  description = "The id of the resource group"
  value = module.resource_group.id
}
output "resource_group_group" {
  description = "The resource group object"
  value = module.resource_group.group
}
output "resource_group_provision" {
  description = "Flag indicating whether the resource group was provisioned"
  value = module.resource_group.provision
}
output "resource_group_sync" {
  description = "Value used to order the provisioning of the resource group"
  value = module.resource_group.sync
}
output "resource_group_region" {
  description = "the value of resource_group_region"
  value = module.resource_group.region
}
output "vnet_name" {
  description = "The name of the VNet instance"
  value = module.vnet.name
}
output "vnet_id" {
  description = "The id of the VNet instance"
  value = module.vnet.id
}
output "vnet_crn" {
  description = "The CRN for the VNet instance"
  value = module.vnet.crn
}
output "vnet_count" {
  description = "The number of VPCs created by this module. Always set to 1"
  value = module.vnet.count
}
output "vnet_names" {
  description = "The name of the vpc instance"
  value = module.vnet.names
}
output "vnet_ids" {
  description = "The id of the vnet instance"
  value = module.vnet.ids
}
output "vnet_addresses" {
  description = "The ip address ranges for the VNet"
  value = module.vnet.addresses
}
output "master_subnet_count" {
  description = "The number of subnets created"
  value = module.master_subnet.count
}
output "master_subnet_name" {
  description = "The name prefix for the subnets"
  value = module.master_subnet.name
}
output "master_subnet_ids" {
  description = "List of the ids created"
  value = module.master_subnet.ids
}
output "master_subnet_id" {
  description = "The id of the first subnet"
  value = module.master_subnet.id
}
output "master_subnet_names" {
  description = "List of the subnet names"
  value = module.master_subnet.names
}
output "master_subnet_subnets" {
  description = "Object list of the subnets - id, zone and label."
  value = module.master_subnet.subnets
}
output "master_subnet_acl_id" {
  description = "Id of the created network security group"
  value = module.master_subnet.acl_id
}
output "master_subnet_vnet_name" {
  description = "Pass-through of the VNet name associated with the subnets"
  value = module.master_subnet.vnet_name
}
output "master_subnet_vnet_id" {
  description = "Pass-through of the VNet id associated with the subnets"
  value = module.master_subnet.vnet_id
}
output "master_subnet_cidr_blocks" {
  description = "List of the CIDR blocks assigned to the subnets"
  value = module.master_subnet.cidr_blocks
}
output "worker_subnet_count" {
  description = "The number of subnets created"
  value = module.worker_subnet.count
}
output "worker_subnet_name" {
  description = "The name prefix for the subnets"
  value = module.worker_subnet.name
}
output "worker_subnet_ids" {
  description = "List of the ids created"
  value = module.worker_subnet.ids
}
output "worker_subnet_id" {
  description = "The id of the first subnet"
  value = module.worker_subnet.id
}
output "worker_subnet_names" {
  description = "List of the subnet names"
  value = module.worker_subnet.names
}
output "worker_subnet_subnets" {
  description = "Object list of the subnets - id, zone and label."
  value = module.worker_subnet.subnets
}
output "worker_subnet_acl_id" {
  description = "Id of the created network security group"
  value = module.worker_subnet.acl_id
}
output "worker_subnet_vnet_name" {
  description = "Pass-through of the VNet name associated with the subnets"
  value = module.worker_subnet.vnet_name
}
output "worker_subnet_vnet_id" {
  description = "Pass-through of the VNet id associated with the subnets"
  value = module.worker_subnet.vnet_id
}
output "worker_subnet_cidr_blocks" {
  description = "List of the CIDR blocks assigned to the subnets"
  value = module.worker_subnet.cidr_blocks
}
output "ingress_subnet_count" {
  description = "The number of subnets created"
  value = module.ingress_subnet.count
}
output "ingress_subnet_name" {
  description = "The name prefix for the subnets"
  value = module.ingress_subnet.name
}
output "ingress_subnet_ids" {
  description = "List of the ids created"
  value = module.ingress_subnet.ids
}
output "ingress_subnet_id" {
  description = "The id of the first subnet"
  value = module.ingress_subnet.id
}
output "ingress_subnet_names" {
  description = "List of the subnet names"
  value = module.ingress_subnet.names
}
output "ingress_subnet_subnets" {
  description = "Object list of the subnets - id, zone and label."
  value = module.ingress_subnet.subnets
}
output "ingress_subnet_acl_id" {
  description = "Id of the created network security group"
  value = module.ingress_subnet.acl_id
}
output "ingress_subnet_vnet_name" {
  description = "Pass-through of the VNet name associated with the subnets"
  value = module.ingress_subnet.vnet_name
}
output "ingress_subnet_vnet_id" {
  description = "Pass-through of the VNet id associated with the subnets"
  value = module.ingress_subnet.vnet_id
}
output "ingress_subnet_cidr_blocks" {
  description = "List of the CIDR blocks assigned to the subnets"
  value = module.ingress_subnet.cidr_blocks
}
output "nsg_id" {
  description = "ID of the created network security group"
  value = module.nsg.id
}
output "nsg_name" {
  description = "Name of the created network security group"
  value = module.nsg.name
}
output "ssh-keys_id" {
  description = "Azure vault identification of the stored key"
  value = module.ssh-keys.id
}
output "ssh-keys_pub_key" {
  description = "Public key"
  value = module.ssh-keys.pub_key
}
output "ssh-keys_pub_key_file" {
  description = "File path of public key"
  value = module.ssh-keys.pub_key_file
}
output "ssh-keys_private_key" {
  description = "Private key"
  value = module.ssh-keys.private_key
  sensitive = true
}
output "ssh-keys_private_key_file" {
  description = "File path of the private key"
  value = module.ssh-keys.private_key_file
}
output "ssh-keys_path" {
  description = "Path to where keys are stored in filesystem"
  value = module.ssh-keys.path
}
output "ssh-keys_name" {
  description = "Name of the key"
  value = module.ssh-keys.name
}
output "vpn-server_id" {
  description = "The Azure id of the created VPN server"
  value = module.vpn-server.id
}
output "vpn-server_vm_public_ip" {
  description = "The public IP address of the created VPN server"
  value = module.vpn-server.vm_public_ip
}
output "vpn-server_vm_public_fqdn" {
  description = "The FQDN of the public IP address"
  value = module.vpn-server.vm_public_fqdn
}
output "vpn-server_admin_username" {
  description = "The administrator username of the created VPN server"
  value = module.vpn-server.admin_username
}
output "vpn-server_vm_private_ip" {
  description = "The private IP address of the created VPN server"
  value = module.vpn-server.vm_private_ip
}
output "vpn-server_client_config_file" {
  description = "The full path and filename of the created VPN client connection file"
  value = module.vpn-server.client_config_file
}
