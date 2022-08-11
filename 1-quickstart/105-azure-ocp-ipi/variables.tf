variable "resource_group_name" {
  type = string
  description = "The name of the resource group that contains the public DNS zone"
}

variable "openshift_version" {
  type = string
  description = "Version of Openshift to install"
}

variable "region" {
  type = string
  description = "The Azure location where the resource group will be provisioned"
}
variable "subscription_id" {
  type = string
  description = "the value of subscription_id"
}
variable "client_id" {
  type = string
  description = "the value of client_id"
}
variable "client_secret" {
  type = string
  description = "the value of client_secret"
}
variable "tenant_id" {
  type = string
  description = "the value of tenant_id"
}

variable "cluster_name" {
  type = string
  description = "The name of the cluster to create"
  default = ""
}

variable "base_domain_name" {
  type = string
}

variable "pull_secret" {
  type = string
}

variable "worker_node_qty" {
    description = "Number of compute/worker nodes to create"
    type        = string
}

variable "worker_node_type" {
    description = "Compute/worker node type"
    type        = string
}

variable "acme_registration_email" {
  type = string
}