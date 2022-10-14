output "id" {
  value         = module.cluster.id
  description   = "Id of the ARO cluster"
}

output "name" {
  value         = module.cluster.name
  description   = "Name of the ARO cluster"
}

output "resource_group_name" {
  value         = module.cluster.resource_group_name
  description   = "Resource group containing the ARO cluster"
}

output "region" {
  value         = module.cluster.region
  description   = "Region containing the ARO cluster"
}

output "config_file_path" {
  value         = module.cluster.config_file_path
  description   = "Path to the config file for the ARO cluster"
}

output "token" {
  value         = module.cluster.token
  description   = "CLI login token for the ARO cluster"
}

output "username" {
  value         = module.cluster.username
  description   = "Login username for the ARO cluster"
}

output "password" {
  value         = module.cluster.password
  description   = "Password for the ARO cluster"
  sensitive     = true
}

output "server_url" {
  value         = module.cluster.serverURL
  description   = "The url used to connect to the API of the cluster"
}