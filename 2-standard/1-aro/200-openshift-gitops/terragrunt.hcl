include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_105 = local.dependencies.names_105
  mock_105 = local.dependencies.mock_105
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_105}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"

}

// Reduce parallelism further for this layer
terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

dependency "aro" {
  config_path = local.cluster_config_path
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
  mock_outputs = {
      server_url = "https://fake.url.org:6443"
      username = "fakeuser"
      password = "fakepassword"
      token = "faketoken"
  }    
}

inputs = {
  server_url = dependency.aro.outputs.cluster_serverURL
  cluster_login_user = dependency.aro.outputs.cluster_username
  cluster_login_password = dependency.aro.outputs.cluster_password
  cluster_login_token= dependency.aro.outputs.cluster_token
}

