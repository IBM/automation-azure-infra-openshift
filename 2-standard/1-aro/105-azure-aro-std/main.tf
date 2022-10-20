module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group?ref=v1.1.1"

  provision = var.resource_group_provision
  region = var.region
  resource_group_name = var.resource_group_name
  sync = var.resource_group_sync
}
module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vnet?ref=v1.1.3"

  address_prefix_count = var.vnet_address_prefix_count
  address_prefixes = var.vnet_address_prefixes == null ? null : jsondecode(var.vnet_address_prefixes)
  base_security_group_name = var.vnet_base_security_group_name
  internal_cidr = var.vnet_internal_cidr
  name = var.vnet_name
  name_prefix = var.name_prefix
  provision = var.vnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
}

// Below custom pending bug fix in subnet module

module "cluster" {
  source = "github.com/cloud-native-toolkit/terraform-azure-aro?ref=v1.0.0"

  name_prefix     = var.name_prefix

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  disable_public_endpoint = true

  pull_secret     = var.pull_secret

  disk_size       = var.cluster_disk_size
  flavor          = var.cluster_flavor
  master_flavor   = var.cluster_master_flavor

  region              = module.resource_group.region
  resource_group_name = module.resource_group.name
  vnet_name           = module.vnet.name
  master_subnet_id    = var.master_subnet_id
  worker_subnet_id    = var.worker_subnet_id
}