output "bin_dir" {
  value = module.azure-ocp-ipi.bin_dir
}

output "config_file_path" {
  value = module.azure-ocp-ipi.config_file_path
}

output "resource_group_name" {
  value = module.azure-ocp-ipi.resource_group_name
}

output "name" {
    value = module.azure-ocp-ipi.name
}

output "server_url" {
    value = module.azure-ocp-ipi.server_url
}

output "username" {
    value = module.azure-ocp-ipi.username
}

output "password" {
    value = module.azure-ocp-ipi.password
    sensitive = true
}

