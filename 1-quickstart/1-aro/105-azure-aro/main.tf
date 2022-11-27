module "cluster" {
  source = "github.com/cloud-native-toolkit/terraform-azure-aro?ref=v2.0.0"

  client_secret = var.client_secret
  disable_public_endpoint = var.cluster_disable_public_endpoint
  encrypt = var.cluster_encrypt
  fips = var.cluster_fips
  key_vault_id = var.cluster_key_vault_id
  label = var.cluster_label
  master_flavor = var.cluster_master_flavor
  master_subnet_id = module.master-subnet.id
  name = var.cluster_name
  name_prefix = var.name_prefix
  os_type = var.cluster_os_type
  pod_cidr = var.cluster_pod_cidr
  provision = var.cluster_provision
  pull_secret = var.pull_secret
  pull_secret_file = var.pull_secret_file
  resource_group_name = module.resource_group.name
  service_cidr = var.cluster_service_cidr
  tags = var.cluster_tags
  vnet_name = module.vnet.name
  worker_count = var.cluster_worker_count
  worker_disk_size = var.cluster_worker_disk_size
  worker_flavor = var.cluster_worker_flavor
  worker_subnet_id = module.worker-subnet.id
}
module "master-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.10"

  acl_rules = var.master-subnet_acl_rules == null ? null : jsondecode(var.master-subnet_acl_rules)
  disable_private_link_endpoint_network_policies = var.master-subnet_disable_private_link_endpoint_network_policies
  disable_private_link_service_network_policies = var.master-subnet_disable_private_link_service_network_policies
  ipv4_cidr_blocks = var.master-subnet_ipv4_cidr_blocks == null ? null : jsondecode(var.master-subnet_ipv4_cidr_blocks)
  label = var.master-subnet_label
  provision = var.master-subnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
  service_endpoints = var.master-subnet_service_endpoints == null ? null : jsondecode(var.master-subnet_service_endpoints)
  subnet_name = var.master-subnet_subnet_name
  vnet_name = module.vnet.name
}
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
module "worker-subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.10"

  acl_rules = var.worker-subnet_acl_rules == null ? null : jsondecode(var.worker-subnet_acl_rules)
  disable_private_link_endpoint_network_policies = var.worker-subnet_disable_private_link_endpoint_network_policies
  disable_private_link_service_network_policies = var.worker-subnet_disable_private_link_service_network_policies
  ipv4_cidr_blocks = var.worker-subnet_ipv4_cidr_blocks == null ? null : jsondecode(var.worker-subnet_ipv4_cidr_blocks)
  label = var.worker-subnet_label
  provision = var.worker-subnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
  service_endpoints = var.worker-subnet_service_endpoints == null ? null : jsondecode(var.worker-subnet_service_endpoints)
  subnet_name = var.worker-subnet_subnet_name
  vnet_name = module.vnet.name
}
