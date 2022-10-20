include "root" {
  path = find_in_parent_folders()
}

locals {
    px_spec = get_env("TF_VAR_portworx_spec")
    dependencies = yamldecode(file("${get_parent_terragrunt_dir()}/layers.yaml"))

    dep_105 = local.dependencies.names_105
    mock_105 = local.dependencies.mock_105
    cluster_config_path = fileexists("${get_parent_terragrunt_dir()}/${local.dep_105}/terragrunt.hcl") ? "${get_parent_terragrunt_dir()}/${local.dep_105}" : "${get_parent_terragrunt_dir()}/.mocks/${local.mock_105}"
}

dependency "aro" {
    config_path = local.cluster_config_path

    mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
    mock_outputs = {
        server_url = "https://fake.url.org:6443"
        username = "fakeuser"
        password = "fakepassword"
    }    
}

inputs = {
    server_url = dependency.aro.outputs.server_url
    cluster_login_user = dependency.aro.outputs.username
    cluster_login_password = dependency.aro.outputs.password
    azure-portworx_portworx_spec = local.px_spec
    azure-portworx_cluster_type = "ARO"
    cluster_login_token= dependency.aro.outputs.token
}