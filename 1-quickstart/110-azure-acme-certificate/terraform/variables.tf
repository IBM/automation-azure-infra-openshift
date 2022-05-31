variable "resource_group_name" {
  type = string
  description = "Resource Group where the public DNS zone is deployed"
}

variable "acme_registration_email" {
  type = string
  description = "Email address used to register with letsencrypt"
}

variable "subscription_id" {
  type = string
  description = "Azure Subscription ID"
}

variable "tenant_id" {
  type = string
  description = "Azure Tenant ID"
}

variable "client_id" {
  type = string
  description = "Azure Client ID"
}

variable "client_secret" {
  type = string
  description = "Azure Client Secret"
}

variable "cluster_name" {
  type = string
  description = "The name of the cluster to create"
  default = ""
}

variable "base_domain_name" {
  type = string
  description = "Base wildcard domain name in the Azure DNS zone (e.g. ocp.myexample.com)"
}

variable "bin_dir" {
  type = string
  description = "Full path to directory containing CLI binaries"
}

variable "config_file_path" {
  type = string
  description = "Full path to kubeconfig file for cluster access"
}


variable "acme_api_endpoint" {
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  description = "ACME API endpoint, defaults to letsencrypt prod directory."
  type = string
}

variable "staging_api_endpoint" {
  default = "https://acme-staging-v02.api.letsencrypt.org/directory"
  description = "Staging Acme API endpoint (used for testing)"
  type = string
}

variable "testing" {
  type = string
  description = "Used during automated code pull and merge testing. Typically set as none"
}
