locals {
  acme_api_endpoint = var.testing == "github" ? var.staging_api_endpoint : var.acme_api_endpoint
}

module "api-certificate" {
  source = "github.com/cloud-native-toolkit/terraform-azure-acme-certificate?ref=v1.0.0"

  domain          = "api.${var.cluster_name}.${var.base_domain_name}"
  wildcard_domain = true

  acme_registration_email = var.acme_registration_email

  acme_api_endpoint = local.acme_api_endpoint

  resource_group_name = var.resource_group_name
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id

}

module "apps-certificate" {
  source = "github.com/cloud-native-toolkit/terraform-azure-acme-certificate?ref=v1.0.0"

  domain          = "apps.${var.cluster_name}.${var.base_domain_name}"
  wildcard_domain = true

  acme_registration_email = var.acme_registration_email

  acme_api_endpoint = local.acme_api_endpoint

  resource_group_name = var.resource_group_name
  client_id = var.client_id
  client_secret = var.client_secret
  subscription_id = var.subscription_id
  tenant_id = var.tenant_id
}

module "api-certs" {
  source = "github.com/cloud-native-toolkit/terraform-any-ocp-ipi-certs?ref=v1.0.1"

  apps_cert         = module.apps-certificate.cert
  apps_key          = module.apps-certificate.key
  apps_issuer_ca    = module.apps-certificate.issuer_ca
  api_cert          = module.api-certificate.cert
  api_key           = module.api-certificate.key
  api_issuer_ca     = module.api-certificate.issuer_ca
  bin_dir           = var.bin_dir
  config_file_path  = var.config_file_path
}
