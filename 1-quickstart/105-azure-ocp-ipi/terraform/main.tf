module "azure-ocp-ipi" {
  source = "github.com/cloud-native-toolkit/terraform-azure-ocp-ipi?ref=v1.1.0"

  name_prefix = var.cluster_name
  domain_resource_group_name = var.resource_group_name  
  region = var.region
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
  pull_secret = var.pull_secret
  base_domain = var.base_domain_name
  openshift_version = var.openshift_version
  worker_node_qty = var.worker_node_qty
  worker_node_type = var.worker_node_type
}

output "bin_dir" {
  value = module.azure-ocp-ipi.bin_dir
}

output "config_file_path" {
  value = module.azure-ocp-ipi.config_file_path
}

output "resource_group_name" {
  value = module.azure-ocp-ipi.resource_group_name
}