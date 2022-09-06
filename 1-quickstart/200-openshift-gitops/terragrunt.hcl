include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

  dep_105 = local.dependencies.names_105
  mock_105 = local.dependencies.mock_105
  cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_105}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"

  names_110 = local.dependencies.names_110
  filtered_names_110 = [for dir in local.names_110 : "${get_parent_terragrunt_dir()}/${dir}" if fileexists("${get_parent_terragrunt_dir()}/${dir}/terragrunt.hcl")]
  certificates_path = length(local.filtered_names_110) > 0 ? local.filtered_names_110[0] : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_110}"
  mock_110 = local.dependencies.mock_110
}

// Reduce parallelism further for this layer
terraform {
  before_hook "pause" {
    commands  = ["apply"]
    execute   = ["sleep","180"]
  }
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

dependency "certificates" {
  config_path = local.certificates_path
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
  mock_outputs = {
      ca_cert = "fake-ca-cert"
  }
}

dependency "ocp-ipi" {
  config_path = local.cluster_config_path
  skip_outputs = false

  mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
  mock_outputs = {
      server_url = "https://fake.url.org:6443"
      username = "fakeuser"
      password = "fakepassword"
  }    
}

inputs = {
  cluster_ca_cert = base64encode("${dependency.certificates.outputs.ca_cert}")
  server_url = dependency.ocp-ipi.outputs.server_url
  cluster_login_user = dependency.ocp-ipi.outputs.username
  cluster_login_password = dependency.ocp-ipi.outputs.password
  cluster_login_token=""
}

