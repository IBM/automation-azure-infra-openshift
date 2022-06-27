output "ca_cert" {
  value = file(var.apps_issuer_ca_file)
  sensitive = true

  depends_on = [
    module.api-certs
  ]
}