variable "gitops-artifactory_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-artifactory_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-artifactory_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-artifactory_storage_class" {
  type = string
  description = "The storage class to use for the persistent volume claim"
  default = ""
}
variable "gitops-artifactory_persistence" {
  type = bool
  description = "Flag to indicate if persistence should be enabled"
  default = true
}
variable "gitops-dashboard_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "openshift"
}
variable "gitops-dashboard_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-dashboard_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-dashboard_image_tag" {
  type = string
  description = "The image version tag to use"
  default = "v1.4.4"
}
variable "tools_namespace_name" {
  type = string
  description = "The value that should be used for the namespace"
  default = "tools"
}
variable "tools_namespace_ci" {
  type = bool
  description = "Flag indicating that this namespace will be used for development (e.g. configmaps and secrets)"
  default = false
}
variable "tools_namespace_create_operator_group" {
  type = bool
  description = "Flag indicating that an operator group should be created in the namespace"
  default = true
}
variable "tools_namespace_argocd_namespace" {
  type = string
  description = "The namespace where argocd has been deployed"
  default = "openshift-gitops"
}
variable "gitops-pact-broker_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-pact-broker_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-pact-broker_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops_repo_host" {
  type = string
  description = "The host for the git repository. The git host used can be a GitHub, GitHub Enterprise, Gitlab, Bitbucket, Gitea or Azure DevOps server. If the host is null assumes in-cluster Gitea instance will be used."
  default = ""
}
variable "gitops_repo_type" {
  type = string
  description = "[Deprecated] The type of the hosted git repository."
  default = ""
}
variable "gitops_repo_org" {
  type = string
  description = "The org/group where the git repository exists/will be provisioned. If the value is left blank then the username org will be used."
  default = ""
}
variable "gitops_repo_project" {
  type = string
  description = "The project that will be used for the git repo. (Primarily used for Azure DevOps repos)"
  default = ""
}
variable "gitops_repo_username" {
  type = string
  description = "The username of the user with access to the repository"
  default = ""
}
variable "gitops_repo_token" {
  type = string
  description = "The personal access token used to access the repository"
  default = ""
}
variable "gitops_repo_gitea_host" {
  type = string
  description = "The host for the default gitea repository."
  default = ""
}
variable "gitops_repo_gitea_org" {
  type = string
  description = "The org/group for the default gitea repository. If not provided, the value will default to the username org"
  default = ""
}
variable "gitops_repo_gitea_username" {
  type = string
  description = "The username of the default gitea repository"
  default = ""
}
variable "gitops_repo_gitea_token" {
  type = string
  description = "The personal access token used to access the repository"
  default = ""
}
variable "gitops_repo_repo" {
  type = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
}
variable "gitops_repo_branch" {
  type = string
  description = "The name of the branch that will be used. If the repo already exists (provision=false) then it is assumed this branch already exists as well"
  default = "main"
}
variable "gitops_repo_public" {
  type = bool
  description = "Flag indicating that the repo should be public or private"
  default = false
}
variable "gitops_repo_gitops_namespace" {
  type = string
  description = "The namespace where ArgoCD is running in the cluster"
  default = "openshift-gitops"
}
variable "gitops_repo_server_name" {
  type = string
  description = "The name of the cluster that will be configured via gitops. This is used to separate the config by cluster"
  default = "default"
}
variable "gitops_repo_sealed_secrets_cert" {
  type = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default = ""
}
variable "gitops_repo_strict" {
  type = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default = false
}
variable "debug" {
  type = bool
  description = "Flag indicating that debug loggging should be enabled"
  default = false
}
variable "gitops-sonarqube_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the IKS cluster."
  default = ""
}
variable "gitops-sonarqube_cluster_type" {
  type = string
  description = "The cluster type (openshift or ocp3 or ocp4 or kubernetes)"
  default = "ocp4"
}
variable "gitops-sonarqube_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-sonarqube_storage_class" {
  type = string
  description = "The storage class to use for the persistent volume claim"
  default = ""
}
variable "gitops-sonarqube_service_account_name" {
  type = string
  description = "The name of the service account that should be used for the deployment"
  default = "sonarqube-sonarqube"
}
variable "gitops-sonarqube_plugins" {
  type = string
  description = "The list of plugins that will be installed on SonarQube"
  default = "[\"https://github.com/checkstyle/sonar-checkstyle/releases/download/4.33/checkstyle-sonar-plugin-4.33.jar\"]"
}
variable "gitops-sonarqube_hostname" {
  type = string
  description = "The hostname that will be used for the ingress/route"
  default = "sonarqube"
}
variable "gitops-sonarqube_persistence" {
  type = bool
  description = "Flag indicating that persistence should be enabled for the pods"
  default = false
}
variable "gitops-sonarqube_cluster_version" {
  type = string
  description = "The cluster version"
  default = ""
}
variable "gitops-swagger-editor_enable_sso" {
  type = bool
  description = "Flag indicating if oauth should be applied (only available for OpenShift)"
  default = true
}
variable "gitops-swagger-editor_tls_secret_name" {
  type = string
  description = "The name of the secret containing the tls certificate values"
  default = ""
}
variable "gitops-swagger-editor_cluster_ingress_hostname" {
  type = string
  description = "Ingress hostname of the cluster."
  default = ""
}
variable "gitops-swagger-editor_cluster_type" {
  type = string
  description = "The cluster type (openshift or kubernetes)"
  default = "openshift"
}
variable "gitops-tekton-resources_task_release" {
  type = string
  description = "The release version of the tekton tasks"
  default = "v3.0.3"
}
variable "util-clis_bin_dir" {
  type = string
  description = "The directory where the clis should be downloaded. If not provided will default to ./bin"
  default = ""
}
variable "util-clis_clis" {
  type = string
  description = "The list of clis that should be made available in the bin directory. Supported values are yq, jq, igc, helm, argocd, rosa, gh, glab, and kubeseal. (If not provided the list will default to yq, jq, and igc)"
  default = "[\"yq\",\"jq\",\"igc\"]"
}
