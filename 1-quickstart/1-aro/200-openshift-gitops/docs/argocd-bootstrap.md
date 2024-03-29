# ArgoCD Bootstrap module

Module to provision ArgoCD and bootstrap an application using the GitOps repo


## Software dependencies

The module depends on the following software components:

### Terraform version

- \>= v0.15

### Terraform providers


None

### Module dependencies


- cluster - interface github.com/cloud-native-toolkit/automation-modules#cluster
- olm - [github.com/cloud-native-toolkit/terraform-k8s-olm](https://github.com/cloud-native-toolkit/terraform-k8s-olm) (>= 1.2.2)
- gitops - [github.com/cloud-native-toolkit/terraform-tools-gitops](https://github.com/cloud-native-toolkit/terraform-tools-gitops) (>= 1.2.0)
- cert - [github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert](https://github.com/cloud-native-toolkit/terraform-util-sealed-secret-cert) (>= 0.0.0)

## Example usage

```hcl
module "argocd-bootstrap" {
  source = "github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap"

  bootstrap_path = module.gitops_repo.bootstrap_path
  bootstrap_prefix = var.argocd-bootstrap_bootstrap_prefix
  cluster_config_file = module.cluster.config_file_path
  cluster_type = module.cluster.platform.type_code
  create_webhook = var.argocd-bootstrap_create_webhook
  git_ca_cert = module.gitops_repo.config_ca_cert
  git_token = module.gitops_repo.config_token
  git_username = module.gitops_repo.config_username
  gitops_repo_url = module.gitops_repo.config_repo_url
  ingress_subdomain = module.cluster.platform.ingress
  olm_namespace = module.olm.olm_namespace
  operator_namespace = module.olm.target_namespace
  sealed_secret_cert = module.sealed-secret-cert.cert
  sealed_secret_private_key = module.sealed-secret-cert.private_key
}

```

## Module details

### Inputs

| Name | Description | Required | Default | Source |
|------|-------------|---------|----------|--------|
| cluster_config_file | Cluster config file for Kubernetes cluster. | true |  | cluster.config_file_path |
| cluster_type | The type of cluster (openshift or kubernetes) | true |  | cluster.platform.type_code |
| olm_namespace | Namespace where olm is installed | true |  | olm.olm_namespace |
| operator_namespace | Namespace where operators will be installed | true |  | olm.target_namespace |
| ingress_subdomain | The subdomain for ingresses in the cluster | true |  | cluster.platform.ingress |
| gitops_repo_url | The GitOps repo url | true |  | gitops.config_repo_url |
| git_username | The username used to access the GitOps repo | true |  | gitops.config_username |
| git_token | The token used to access the GitOps repo | true |  | gitops.config_token |
| git_ca_cert | Base64 encoded ca cert of the gitops repository | true |  | gitops.config_ca_cert |
| bootstrap_path | The path to the bootstrap config for ArgoCD | true |  | gitops.bootstrap_path |
| sealed_secret_cert | The certificate that will be used to encrypt sealed secrets. If not provided, a new one will be generated | true |  | cert.cert |
| sealed_secret_private_key | The private key that will be used to decrypt sealed secrets. If not provided, a new one will be generated | true |  | cert.private_key |
| bootstrap_prefix | The prefix used in ArgoCD to bootstrap the application | true |  |  |
| create_webhook | Flag indicating that a webhook should be created in the gitops repo to notify argocd of changes | true |  |  |

### Outputs

| Name | Description |
|------|-------------|
| argocd_namespace | The namespace where the ArgoCD instance has been provisioned |
| argocd_service_account | The namespace where the ArgoCD instance has been provisioned |
| sealed_secrets_cert |  |

## Resources

- [Documentation](https://operate.cloudnativetoolkit.dev)
- [Module catalog](https://modules.cloudnativetoolkit.dev)

> License: Apache License 2.0 | Generated by iascable (3.3.0)
