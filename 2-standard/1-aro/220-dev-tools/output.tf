output "gitops-artifactory_name" {
  description = "The name of the module"
  value = module.gitops-artifactory.name
}
output "gitops-artifactory_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-artifactory.branch
}
output "gitops-artifactory_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-artifactory.namespace
}
output "gitops-artifactory_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-artifactory.server_name
}
output "gitops-artifactory_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-artifactory.layer
}
output "gitops-artifactory_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-artifactory.type
}
output "gitops-dashboard_name" {
  description = "The name of the module"
  value = module.gitops-dashboard.name
}
output "gitops-dashboard_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-dashboard.branch
}
output "gitops-dashboard_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-dashboard.namespace
}
output "gitops-dashboard_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-dashboard.server_name
}
output "gitops-dashboard_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-dashboard.layer
}
output "gitops-dashboard_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-dashboard.type
}
output "tools_namespace_name" {
  description = "Namespace name"
  value = module.tools_namespace.name
}
output "gitops-pact-broker_name" {
  description = "The name of the module"
  value = module.gitops-pact-broker.name
}
output "gitops-pact-broker_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-pact-broker.branch
}
output "gitops-pact-broker_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-pact-broker.namespace
}
output "gitops-pact-broker_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-pact-broker.server_name
}
output "gitops-pact-broker_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-pact-broker.layer
}
output "gitops-pact-broker_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-pact-broker.type
}
output "gitops_repo_config_host" {
  description = "The host name of the bootstrap git repo"
  value = module.gitops_repo.config_host
}
output "gitops_repo_config_org" {
  description = "The org name of the bootstrap git repo"
  value = module.gitops_repo.config_org
}
output "gitops_repo_config_name" {
  description = "The repo name of the bootstrap git repo"
  value = module.gitops_repo.config_name
}
output "gitops_repo_config_project" {
  description = "The project name of the bootstrap git repo (for Azure DevOps)"
  value = module.gitops_repo.config_project
}
output "gitops_repo_config_repo" {
  description = "The repo that contains the argocd configuration"
  value = module.gitops_repo.config_repo
}
output "gitops_repo_config_repo_url" {
  description = "The repo that contains the argocd configuration"
  value = module.gitops_repo.config_repo_url
}
output "gitops_repo_config_ca_cert" {
  description = "The ca cert for the self-signed certificate used by the gitops repo"
  value = module.gitops_repo.config_ca_cert
}
output "gitops_repo_config_username" {
  description = "The username for the config repo"
  value = module.gitops_repo.config_username
}
output "gitops_repo_config_token" {
  description = "The token for the config repo"
  value = module.gitops_repo.config_token
  sensitive = true
}
output "gitops_repo_config_paths" {
  description = "The paths in the config repo"
  value = module.gitops_repo.config_paths
}
output "gitops_repo_config_projects" {
  description = "The ArgoCD projects for the different layers of the repo"
  value = module.gitops_repo.config_projects
}
output "gitops_repo_bootstrap_path" {
  description = "The path to the bootstrap configuration"
  value = module.gitops_repo.bootstrap_path
}
output "gitops_repo_bootstrap_branch" {
  description = "The branch in the gitrepo containing the bootstrap configuration"
  value = module.gitops_repo.bootstrap_branch
}
output "gitops_repo_application_repo" {
  description = "The repo that contains the application configuration"
  value = module.gitops_repo.application_repo
}
output "gitops_repo_application_repo_url" {
  description = "The repo that contains the application configuration"
  value = module.gitops_repo.application_repo_url
}
output "gitops_repo_application_username" {
  description = "The username for the application repo"
  value = module.gitops_repo.application_username
}
output "gitops_repo_application_token" {
  description = "The token for the application repo"
  value = module.gitops_repo.application_token
  sensitive = true
}
output "gitops_repo_application_paths" {
  description = "The paths in the application repo"
  value = module.gitops_repo.application_paths
}
output "gitops_repo_gitops_config" {
  description = "Config information regarding the gitops repo structure"
  value = module.gitops_repo.gitops_config
}
output "gitops_repo_git_credentials" {
  description = "The credentials for the gitops repo(s)"
  value = module.gitops_repo.git_credentials
  sensitive = true
}
output "gitops_repo_server_name" {
  description = "The name of the cluster that will be configured for gitops"
  value = module.gitops_repo.server_name
}
output "gitops_repo_sealed_secrets_cert" {
  description = "The certificate used to encrypt sealed secrets"
  value = module.gitops_repo.sealed_secrets_cert
}
output "gitops-sonarqube_name" {
  description = "The name of the module"
  value = module.gitops-sonarqube.name
}
output "gitops-sonarqube_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-sonarqube.branch
}
output "gitops-sonarqube_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-sonarqube.namespace
}
output "gitops-sonarqube_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-sonarqube.server_name
}
output "gitops-sonarqube_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-sonarqube.layer
}
output "gitops-sonarqube_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-sonarqube.type
}
output "gitops-sonarqube_postgresql" {
  description = "Properties for an existing postgresql database"
  value = module.gitops-sonarqube.postgresql
}
output "gitops-swagger-editor_name" {
  description = "The name of the module"
  value = module.gitops-swagger-editor.name
}
output "gitops-swagger-editor_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-swagger-editor.branch
}
output "gitops-swagger-editor_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-swagger-editor.namespace
}
output "gitops-swagger-editor_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-swagger-editor.server_name
}
output "gitops-swagger-editor_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-swagger-editor.layer
}
output "gitops-swagger-editor_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-swagger-editor.type
}
output "gitops-tekton-resources_name" {
  description = "The name of the module"
  value = module.gitops-tekton-resources.name
}
output "gitops-tekton-resources_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-tekton-resources.branch
}
output "gitops-tekton-resources_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-tekton-resources.namespace
}
output "gitops-tekton-resources_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-tekton-resources.server_name
}
output "gitops-tekton-resources_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-tekton-resources.layer
}
output "gitops-tekton-resources_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-tekton-resources.type
}
output "util-clis_bin_dir" {
  description = "Directory where the clis were downloaded"
  value = module.util-clis.bin_dir
}
output "gitops-buildah-unprivileged_name" {
  description = "The name of the module"
  value = module.gitops-buildah-unprivileged.name
}
output "gitops-buildah-unprivileged_branch" {
  description = "The branch where the module config has been placed"
  value = module.gitops-buildah-unprivileged.branch
}
output "gitops-buildah-unprivileged_namespace" {
  description = "The namespace where the module will be deployed"
  value = module.gitops-buildah-unprivileged.namespace
}
output "gitops-buildah-unprivileged_server_name" {
  description = "The server where the module will be deployed"
  value = module.gitops-buildah-unprivileged.server_name
}
output "gitops-buildah-unprivileged_layer" {
  description = "The layer where the module is deployed"
  value = module.gitops-buildah-unprivileged.layer
}
output "gitops-buildah-unprivileged_type" {
  description = "The type of module where the module is deployed"
  value = module.gitops-buildah-unprivileged.type
}
