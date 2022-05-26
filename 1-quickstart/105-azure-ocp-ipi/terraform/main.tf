module "azure-ocp-ipi" {
  source = "github.com/cloud-native-toolkit/terraform-azure-ocp-ipi?ref=v1.0.1"

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
}