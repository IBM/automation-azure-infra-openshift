module "ingress_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.10"

  acl_rules = var.ingress_subnet_acl_rules == null ? null : jsondecode(var.ingress_subnet_acl_rules)
  disable_private_link_endpoint_network_policies = var.ingress_subnet_disable_private_link_endpoint_network_policies
  disable_private_link_service_network_policies = var.ingress_subnet_disable_private_link_service_network_policies
  ipv4_cidr_blocks = var.ingress_subnet_ipv4_cidr_blocks == null ? null : jsondecode(var.ingress_subnet_ipv4_cidr_blocks)
  label = var.ingress_subnet_label
  provision = var.ingress_subnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
  service_endpoints = var.ingress_subnet_service_endpoints == null ? null : jsondecode(var.ingress_subnet_service_endpoints)
  subnet_name = var.ingress_subnet_subnet_name
  vnet_name = module.vnet.name
}
module "master_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.10"

  acl_rules = var.master_subnet_acl_rules == null ? null : jsondecode(var.master_subnet_acl_rules)
  disable_private_link_endpoint_network_policies = var.master_subnet_disable_private_link_endpoint_network_policies
  disable_private_link_service_network_policies = var.master_subnet_disable_private_link_service_network_policies
  ipv4_cidr_blocks = var.master_subnet_ipv4_cidr_blocks == null ? null : jsondecode(var.master_subnet_ipv4_cidr_blocks)
  label = var.master_subnet_label
  provision = var.master_subnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
  service_endpoints = var.master_subnet_service_endpoints == null ? null : jsondecode(var.master_subnet_service_endpoints)
  subnet_name = var.master_subnet_subnet_name
  vnet_name = module.vnet.name
}
module "nsg" {
  source = "github.com/cloud-native-toolkit/terraform-azure-nsg?ref=v1.0.5"

  acl_rules = var.nsg_acl_rules == null ? null : jsondecode(var.nsg_acl_rules)
  name = var.nsg_name
  name_prefix = var.name_prefix
  region = var.region
  resource_group_name = module.resource_group.name
  subnet_ids = module.ingress_subnet.ids
  virtual_network_name = module.vnet.name
}
module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group?ref=v1.1.1"

  provision = var.resource_group_provision
  region = var.region
  resource_group_name = var.resource_group_name
  sync = var.resource_group_sync
}
module "ssh-keys" {
  source = "github.com/cloud-native-toolkit/terraform-azure-ssh-key?ref=v1.0.6"

  algorithm = var.ssh-keys_algorithm
  ecdsa_curve = var.ssh-keys_ecdsa_curve
  key_name = var.ssh-keys_key_name
  name_prefix = var.name_prefix
  private_file_permissions = var.ssh-keys_private_file_permissions
  public_file_permissions = var.ssh-keys_public_file_permissions
  region = var.region
  resource_group_name = module.resource_group.name
  rsa_bits = var.ssh-keys_rsa_bits
  ssh_key = var.ssh-keys_ssh_key
  store_key_in_vault = var.ssh-keys_store_key_in_vault
  store_path = var.ssh-keys_store_path
  tags = var.ssh-keys_tags
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
module "vpn-server" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpn-server?ref=v1.0.1"

  admin_username = var.vpn-server_admin_username
  bootstrap_script = var.vpn-server_bootstrap_script
  client_network = var.vpn-server_client_network
  client_network_bits = var.vpn-server_client_network_bits
  name_prefix = var.vpn-server_name_prefix
  private_dns = var.vpn-server_private_dns == null ? null : jsondecode(var.vpn-server_private_dns)
  private_ip_address_allocation_type = var.vpn-server_private_ip_address_allocation_type
  private_key_file = module.ssh-keys.private_key_file
  private_network_cidrs = var.vpn-server_private_network_cidrs == null ? null : jsondecode(var.vpn-server_private_network_cidrs)
  pub_ssh_key_file = module.ssh-keys.pub_key_file
  resource_group_name = module.resource_group.name
  storage_type = var.vpn-server_storage_type
  subnet_id = module.ingress_subnet.id
  virtual_network_name = module.vnet.name
  vm_public_ip_allocation_method = var.vpn-server_vm_public_ip_allocation_method
  vm_public_ip_sku = var.vpn-server_vm_public_ip_sku
  vm_size = var.vpn-server_vm_size
}
module "worker_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets?ref=v1.3.10"

  acl_rules = var.worker_subnet_acl_rules == null ? null : jsondecode(var.worker_subnet_acl_rules)
  disable_private_link_endpoint_network_policies = var.worker_subnet_disable_private_link_endpoint_network_policies
  disable_private_link_service_network_policies = var.worker_subnet_disable_private_link_service_network_policies
  ipv4_cidr_blocks = var.worker_subnet_ipv4_cidr_blocks == null ? null : jsondecode(var.worker_subnet_ipv4_cidr_blocks)
  label = var.worker_subnet_label
  provision = var.worker_subnet_provision
  region = var.region
  resource_group_name = module.resource_group.name
  service_endpoints = var.worker_subnet_service_endpoints == null ? null : jsondecode(var.worker_subnet_service_endpoints)
  subnet_name = var.worker_subnet_subnet_name
  vnet_name = module.vnet.name
}
