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
variable "master-subnet_subnet_name" {
  type = string
  description = "The name of the subnet instance"
  default = ""
}
variable "master-subnet_label" {
  type = string
  description = "Label for the subnets created"
  default = "master"
}
variable "master-subnet_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = true
}
variable "master-subnet_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.1.0/24\"]"
}
variable "master-subnet_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
variable "master-subnet_service_endpoints" {
  type = string
  description = "The list of service endpoints for the subnet"
  default = "[\"Microsoft.ContainerRegistry\",\"Microsoft.Storage\"]"
}
variable "master-subnet_disable_private_link_endpoint_network_policies" {
  type = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default = false
}
variable "worker-subnet_subnet_name" {
  type = string
  description = "The name of the subnet instance"
  default = ""
}
variable "worker-subnet_label" {
  type = string
  description = "Label for the subnets created"
  default = "worker"
}
variable "worker-subnet_provision" {
  type = bool
  description = "Flag indicating that the subnet should be provisioned. If 'false' then the subnet will be looked up."
  default = true
}
variable "worker-subnet_ipv4_cidr_blocks" {
  type = string
  description = "List of ipv4 cidr blocks for the subnets that will be created (e.g. ['10.10.10.0/24']). If you are providing cidr blocks then a value must be provided for each of the subnets. If you don't provide cidr blocks for each of the subnets then values will be generated using the {ipv4_address_count} value."
  default = "[\"10.0.2.0/24\"]"
}
variable "worker-subnet_acl_rules" {
  type = string
  description = "List of rules to set on the subnet access control list"
  default = "[]"
}
variable "worker-subnet_service_endpoints" {
  type = string
  description = "The list of service endpoints for the subnet"
  default = "[\"Microsoft.ContainerRegistry\",\"Microsoft.Storage\"]"
}
variable "worker-subnet_disable_private_link_endpoint_network_policies" {
  type = bool
  description = "Flag to disable private link endpoint network policies in the subnet."
  default = false
}
variable "cluster_openshift_version" {
  type = string
  description = "The version of the openshift cluster"
  default = "4.8.11"
}
variable "cluster_master_flavor" {
  type = string
  description = "The size of the VMs for the master nodes"
  default = "Standard_D8s_v3"
}
variable "cluster_flavor" {
  type = string
  description = "The size of the VMs for the worker nodes"
  default = "Standard_D4s_v3"
}
variable "cluster__count" {
  type = number
  description = "The number of compute worker nodes"
  default = 3
}
variable "cluster_os_type" {
  type = string
  description = "The type of os for the master and worker nodes"
  default = "Linux"
}
variable "cluster_provision" {
  type = bool
  description = "Flag indicating the cluster should be provisioned. If the value is false then an existing cluster will be looked up"
  default = true
}
variable "cluster_name" {
  type = string
  description = "The name of the ARO cluster. If empty the name will be derived from the name prefix"
  default = ""
}
variable "cluster_auth_group_id" {
  type = string
  description = "The id of the auth group for cluster admins"
  default = ""
}
variable "cluster_disable_public_endpoint" {
  type = bool
  description = "Flag to make the cluster private only"
  default = false
}
variable "cluster_disk_size" {
  type = number
  description = "The size in GB of the disk for each worker node"
  default = 128
}
variable "pull_secret" {
  type = string
  description = "The contents of the pull secret needed to access Red Hat content. The contents can either be provided directly or passed through the `pull_secret_file` variable"
  default = ""
}
variable "pull_secret_file" {
  type = string
  description = "Name of the file containing the pull secret needed to access Red Hat content. The contents can either be provided in this file or directly via the `pull_secret` variable"
  default = ""
}
variable "cluster_label" {
  type = string
  description = "The label used to generate the cluster name"
  default = "cluster"
}
