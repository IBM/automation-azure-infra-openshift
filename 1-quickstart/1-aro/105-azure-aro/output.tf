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
output "master-subnet_count" {
  description = "The number of subnets created"
  value = module.master-subnet.count
}
output "master-subnet_name" {
  description = "The name prefix for the subnets"
  value = module.master-subnet.name
}
output "master-subnet_ids" {
  description = "List of the ids created"
  value = module.master-subnet.ids
}
output "master-subnet_id" {
  description = "The id of the first subnet"
  value = module.master-subnet.id
}
output "master-subnet_names" {
  description = "List of the subnet names"
  value = module.master-subnet.names
}
output "master-subnet_subnets" {
  description = "Object list of the subnets - id, zone and label."
  value = module.master-subnet.subnets
}
output "master-subnet_acl_id" {
  description = "Id of the created network security group"
  value = module.master-subnet.acl_id
}
output "master-subnet_vnet_name" {
  description = "Pass-through of the VNet name associated with the subnets"
  value = module.master-subnet.vnet_name
}
output "master-subnet_vnet_id" {
  description = "Pass-through of the VNet id associated with the subnets"
  value = module.master-subnet.vnet_id
}
output "master-subnet_cidr_blocks" {
  description = "List of the CIDR blocks assigned to the subnets"
  value = module.master-subnet.cidr_blocks
}
output "worker-subnet_count" {
  description = "The number of subnets created"
  value = module.worker-subnet.count
}
output "worker-subnet_name" {
  description = "The name prefix for the subnets"
  value = module.worker-subnet.name
}
output "worker-subnet_ids" {
  description = "List of the ids created"
  value = module.worker-subnet.ids
}
output "worker-subnet_id" {
  description = "The id of the first subnet"
  value = module.worker-subnet.id
}
output "worker-subnet_names" {
  description = "List of the subnet names"
  value = module.worker-subnet.names
}
output "worker-subnet_subnets" {
  description = "Object list of the subnets - id, zone and label."
  value = module.worker-subnet.subnets
}
output "worker-subnet_acl_id" {
  description = "Id of the created network security group"
  value = module.worker-subnet.acl_id
}
output "worker-subnet_vnet_name" {
  description = "Pass-through of the VNet name associated with the subnets"
  value = module.worker-subnet.vnet_name
}
output "worker-subnet_vnet_id" {
  description = "Pass-through of the VNet id associated with the subnets"
  value = module.worker-subnet.vnet_id
}
output "worker-subnet_cidr_blocks" {
  description = "List of the CIDR blocks assigned to the subnets"
  value = module.worker-subnet.cidr_blocks
}
output "cluster_id" {
  description = "ID of the created cluster"
  value = module.cluster.id
}
output "cluster_name" {
  description = "Name of the cluster"
  value = module.cluster.name
}
output "cluster_resource_group_name" {
  description = "Name of the resource group containing the cluster."
  value = module.cluster.resource_group_name
}
output "cluster_region" {
  description = "Region containing the cluster."
  value = module.cluster.region
}
output "cluster_config_file_path" {
  description = "Path to the config file for the cluster"
  value = module.cluster.config_file_path
}
output "cluster_token" {
  description = "Login token for the cluster"
  value = module.cluster.token
  sensitive = true
}
output "cluster_console_url" {
  description = "The URL for the web console of the cluster"
  value = module.cluster.console_url
}
output "cluster_username" {
  description = "Username for the cluster"
  value = module.cluster.username
}
output "cluster_password" {
  description = "Password for the cluster"
  value = module.cluster.password
  sensitive = true
}
output "cluster_serverURL" {
  description = "The URL used to connect to the API of the cluster"
  value = module.cluster.serverURL
}
output "cluster_platform" {
  description = "Configuration values for the created cluster platform"
  value = module.cluster.platform
  sensitive = true
}
output "cluster_sync" {
  description = "Value used to sync downstream modules"
  value = module.cluster.sync
}
