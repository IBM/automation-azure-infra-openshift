include "root" {
  path = find_in_parent_folders()
}

locals {
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_200 = local.dependencies.names_200
    mock_200 = local.dependencies.mock_200
}

// Reduce parallelism further for this layer
terraform {
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=2"]
  }
}

dependency "gitops" {
  config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_200}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_200}"
  skip_outputs = fileexists("${get_parent_terragrunt_dir()}/${local.dep_200}/terragrunt.hcl") ? false : true
  # skip_outputs = true

  mock_outputs_allowed_terraform_commands = ["validate", "init", "plan", "destroy", "output"]
  mock_outputs = {
    gitops_host = ""
    gitops_org = ""
    gitops_name = ""
    gitops_project = ""
    gitops_username = ""
    gitops_token = ""
  }
}

inputs = {
  gitops_repo_host = dependency.gitops.outputs.gitops_repo_config_host
  gitops_repo_org = dependency.gitops.outputs.gitops_repo_config_org
  gitops_repo_repo = dependency.gitops.outputs.gitops_repo_config_name
  gitops_repo_project = dependency.gitops.outputs.gitops_repo_config_project
  gitops_repo_username = dependency.gitops.outputs.gitops_repo_config_username
  gitops_repo_token = dependency.gitops.outputs.gitops_repo_config_token
}