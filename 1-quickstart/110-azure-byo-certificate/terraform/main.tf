module "api-certs" {
  source = "github.com/cloud-native-toolkit/terraform-any-ocp-ipi-certs?ref=v1.0.2"

  api_cert = file(var.api_cert_file)
  api_issuer_ca = file(var.api_issuer_ca_file)
  api_key = file(var.api_key_file)
  apps_cert = file(var.apps_cert_file)
  apps_issuer_ca = file(var.apps_issuer_ca_file)
  apps_key = file(var.apps_key_file)
  bin_dir = var.bin_dir
  config_file_path = var.config_file_path
}
