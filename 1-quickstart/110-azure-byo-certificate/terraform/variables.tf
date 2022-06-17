
variable "apps_cert_file" {
  type = string
  description = "Path to default ingress certificate"
}
variable "apps_key_file" {
  type = string
  description = "Path to default ingress certificate key"
}
variable "apps_issuer_ca_file" {
  type = string
  description = "Path to default ingress certificate issuer CA"
}
variable "api_cert_file" {
  type = string
  description = "Path to API Server certificate"
}
variable "api_key_file" {
  type = string
  description = "Path to API Server certificate key"
}
variable "api_issuer_ca_file" {
  type = string
  description = "Path to API Server certificate issuer CA"
}
variable "bin_dir" {
  type = string
  description = "Path to directory where binaries can be found."
}
variable "config_file_path" {
  type = string
  description = "Path to kube config."
}
