include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_101 = local.dependencies.names_101
  mock_101 = local.dependencies.mock_101
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_101}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_101}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_101}"

}

dependency "vnet" {
  config_path = local.cluster_config_path
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
  mock_outputs = {
    resource_group_name  = "fake-rg"
    vnet_name            = "fake-vnet"
    master_subnet_name   = "fake-master"
    worker_subnet_name   = "fake-worker"
  }    
}

inputs = {
    resource_group_name  = dependency.vnet.outputs.resource_group_name
    vnet_name            = dependency.vnet.outputs.vnet_name
    master_subnet_id     = dependency.vnet.outputs.master_subnet_id
    worker_subnet_id     = dependency.vnet.outputs.worker_subnet_id
}