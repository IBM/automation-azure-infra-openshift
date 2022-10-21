
output "cluster_id" {
  description = "ID of the created cluster"
  value = module.cluster.id
}
output "cluster_name" {
  description = "Name of the cluster"
  value = module.cluster.name
}
output "cluster_resource_group_name" {
  description = "Name of the resource group containing the cluster."
  value = module.cluster.resource_group_name
}
output "cluster_region" {
  description = "Region containing the cluster."
  value = module.cluster.region
}
output "cluster_config_file_path" {
  description = "Path to the config file for the cluster"
  value = module.cluster.config_file_path
}
output "cluster_token" {
  description = "Login token for the cluster"
  value = module.cluster.token
}
output "cluster_username" {
  description = "Username for the cluster"
  value = module.cluster.username
}
output "cluster_password" {
  description = "Password for the cluster"
  value = module.cluster.password
  sensitive = true
}
output "cluster_serverURL" {
  description = "The URL used to connect to the API of the cluster"
  value = module.cluster.serverURL
}
output "cluster_platform" {
  description = "Configuration values for the created cluster platform"
  value = module.cluster.platform
  sensitive = true
}
output "cluster_sync" {
  description = "Value used to sync downstream modules"
  value = module.cluster.sync
}
output "cluster_total_worker_count" {
  description = "The total number of workers for the cluster. (subnets * number of workers)"
  value = module.cluster.total_worker_count
}
