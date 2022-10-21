include "root" {
  path = find_in_parent_folders()
}

locals {
  dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_105 = local.dependencies.names_105
    mock_105 = local.dependencies.mock_105
    cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_105}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"
}

dependencies {
    paths = ["${local.cluster_config_path}"]
}