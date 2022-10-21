# Azure Standard Reference Architecture - Azure RedHat OpenShift (ARO)

Automation to provision the Standard reference architecture on Azure. This architecture implements the minimum infrastructure required to stand up a managed Red Hat OpenShift cluster with private endpoints.

## Reference Architecture

![Standard](architecture.png)

The automation is delivered in a number of layers that are applied in order. Layer (such as `200`) provisions the infrastructure including the Red Hat OpenShift cluster and the remaining layers provide configuration inside the cluster. Each layer depends on resources provided in the layer before it (e.g. `200` depends on `105`). Where two layers have the same numbers (e.g. `210`), you have a choice of which layer to apply.


<table>
<thead>
<tr>
<th>Layer name</th>
<th>Layer description</th>
<th>Provided resources</th>
</tr>
</thead>

<tbody>

<tr>
<td>101 - Azure VNet Standard</td>
<td>This layer provisions the Azure private VNet, VPN server and associated services. </td>
<td>
<h4>Network</h4>
<ul>
<li>Virtual network</li>
<li>Ingress, Master and Worker Subnets</li>
<li>Network Security Group</li>
<li>SSH keys and Key Vault</li>
<li>VPN Server</li>
</ul>
</td>
</tr>

<tr>
<td>105 - Azure ARO</td>
<td>This layer provisions the Azure OpenShift cluster within the created private VNet. </td>
<td>
<h4>Network</h4>
<ul>
<li>Network Security Group</li>
<li>Internal Load Balancer</li>
<li>Red Hat OpenShift cluster</li>
</ul>
</td>
</tr>

<tr>
<td>200 - IBM OpenShift Gitops</td>
<td>This layer provisions OpenShift CI/CD tools into the cluster, a GitOps repository, and bootstraps the repository to the OpenShift Gitops instance.</td>
<td>
<h4>Software</h4>
<ul>
<li>OpenShift GitOps (ArgoCD)</li>
<li>OpenShift Pipelines (Tekton)</li>
<li>Sealed Secrets (Kubeseal)</li>
<li>GitOps repo</li>
</ul>
</td>
</tr>
<tr>

<tr>
<td>210 - Azure Storage</td>
<td>The storage layer has two options - default or Portworx. The default option uses Azure's storage for OpenShift persistent volumes. For quickstart, this is Premium_LRS. Other options can be configured post implementation through the OpenShift console. The Portworx option implements either a Portworx Essentials or Portworx Enterprise deployment onto the OpenShift cluster. The type of Portworx deployment is determined by the supplied Portworx specification file. </td>
<td>
<h4>Default</h4>
<ul>
<li>Azure storage class
</ul>
<h4>Portworx</h4>
<ul>
<li>Portworx operator</li>
<li>Portworx storage classes</li>
</ul>
</td>
</tr>

<tr>
<td>220 - Dev Tools</td>
<td>The dev tools layer installs standard continuous integration (CI) pipelines that integrate with tools that support the software development lifecycle.</td>
<td>
<h4>Software</h4>
<ul>
<li>Artifactory</li>
<li>Developer Dashboard</li>
<li>Pact Broker</li>
<li>Sonarqube</li>
<li>Tekton Resources</li>
</ul>
</td>
</tr>

</tbody>
</table>

## Automation

### Prerequisites

1. Access to an Azure account with "Owner" and "User Access Administrator" roles in an Azure Subscription. The user must be able to create a service principal per the below prerequisite.

2. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
    This is required to setup the service principal per the below instructions and to setup the ARO cluster. If using the container approach, the CLI is included in the cli-tools image.

4. [Create a Service Principal](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/credentials.md) with proper IAM roles.
    1. Create the service principal account if it does not already exist:
        ```shell
         az ad sp create-for-rbac --role Contributor --name <service_principal_name> --scopes /subscriptions/$SUBSCRIPTION_ID
        ```
        where SUBSCRIPTION_ID is the Azure subscription where the cluster is to be deployed and `service_principal_name` is the name to be assigned to the service principal. 
        Make a copy of the details provided
        ```json
        "addId":"<this is the CLIENT_ID value>",
        "displayName":"<service principal name>",
        "password":"<this is the CLIENT_SECRET value>",
        "tenant":"<this is the TENANT_ID value>"
        ```

    1. Give permissions to the service principal to create other service principals and the ARO cluster (refer [here](./sp-setup.md) for details)

5. Get your [OpenShift installer pull secret](https://console.redhat.com/openshift/install/pull-secret) and save it in `./pull-secret`. If a pull secret is not included, the ARO cluster will still be deployed, however, it will not have access to additional Red Hat features.

6. (Optional) Install and start Colima to run the terraform tools in a local bootstrapped container image.

    ```shell
    brew install docker colima
    colima start
    ```

### Setup

1. Clone this repository to your local SRE laptop or into a secure terminal. Open a shell into the cloned directory.
2. Copy **credentials.template** to **credentials.properties**.
    ```shell
    cp credentials.template credentials.properties
    ```
3. Provide values for the variables in **credentials.properties** (**Note:** `*.properties` has been added to **.gitignore** to ensure that the file containing the apikey cannot be checked into Git.)
    - **TF_VAR_subscription_id** - The Azure subscription id where the cluster will be deployed
    - **TF_VAR_tenant_id** - The Azure tenant id that owns the subscription
    - **TV_VAR_client_id** - The id of the service principal with Owner and User Administrator access to the subscription for cluster creation
    - **TV_VAR_client_secret** - The password of the service principal with Owner and User Administrator access to the subscription for cluster creation
    - **TV_VAR_pull_secret** - The contents of the Red Hat OpenShift pull secret downloaded in the prerequsite steps
    - **TF_VAR_acme_registration_email** - (Optional) If using an auto-generated ingress certificate, this is the email address with which to register the certificate with LetsEncrypt.
    - **TF_VAR_testing** - This value is used to determine whether testing or staging variables should be utilised. Lease as `none` for production deployments. A value other than `none` will request in a non-production deployment.
    - **TF_VAR_portworx_spec** - A base64 encoded string of the Portworx specificatin yaml file. If left blank and using Portworx, ensure you specify the path to the Portworx specification yaml file in the `terraform.tfvars` file. For a Portworx implementation, either the `portworx_spec` or the `portworx_spec_file` values must be specified. If neither if specified, Portworx will not implement correctly.
    - **TF_VAR_gitops_repo_username** - The username for the gitops repository (leave blank if using GiTea)
    - **TF_VAR_gitops_repo_token** - The access token for the gitops repository (leave blank if using GiTea)
    - **TF_VAR_gitops_repo_org** - The organisation for the gitops repository (leave blank if using a personal repository or using GiTea)

4. Run **./launch.sh**. This will start a container image with the prompt opened in the `/terraform` directory, pointed to the repo directory.
5. Create a working copy of the terraform by running **./setup-workspace.sh**. The script makes a copy of the terraform in `/workspaces/current` and set up a "terraform.tfvars" file populated with default values. The script can be run interactively by just running **./setup-workspace.sh** or by providing command line parameters as specified below.
    ```
    Usage: setup-workspace.sh [-f FLAVOR] [-s STORAGE] [-c CERT_TYPE] [-r REGION] [-n PREFIX_NAME]
    
    where:
      - **FLAVOR** - the type of deployment `quickstart`, `standard` or `advanced`. If not provided, will default to quickstart.
      - **STORAGE** - The storage provider. Possible options are `portworx` or `odf`. If not provided as an argument, a prompt will be shown.
      - **CERT_TYPE** - The type of ingress certificate to apply. Possible options are `acme` or `byo`. Acme will obtain certificates from LetsEncrypt for the new cluster. BYO requires providing the paths to valid certificates in the **terraform.tfvars** file.
      - **REGION** - the Azure location where the infrastructure will be provided ([available regions](https://docs.microsoft.com/en-us/azure/availability-zones/az-overview)). Codes for each location can be obtained from the CLI using,
            ```shell
            az account list-locations -o table
            ```
        If not provided the value defaults to `eastus`
      - **PREFIX_NAME** - the name prefix that should be added to all the resources. If not provided a prefix will not be added.
    ```
6. Change the directory to the current workspace where the automation was configured (e.g. `/workspaces/current`).
7. Inspect **terraform.tfvars** to see if there are any variables that should be changed. (The **setup-workspace.sh** script has generated **terraform.tfvars** with default values. At a minimum, modify the ***base_domain_name*** and ***resource_group_name*** values to suit the Azure DNS zone configured in the prerequisite steps. )
    - **base_domain_name** - the full subdomain delegated to Azure in the DNS zone (for example ocp.azure.example.com)
    - **resource_group_name** - the Azure resource group where the DNS zone has been defined

    **Note:** A soft link has been created to the **terraform.tfvars** in each of the terraform subdirectories so the configuration is shared between all of them. 

#### Run all the terraform layers automatically

From the **/workspace/current** directory, run the following:

```
./apply-all.sh -a
```

The script will run through each of the terraform layers in sequence to provision the entire infrastructure.

#### Run all the terraform layers manually

From the **/workspace/current** directory, change directory into each of the layer subdirectories and run the following:

```shell
terragrunt init
terragrunt apply -auto-approve
```

### Obtain login information

Once the installation is complete, the login details can be obtained using the following steps:
```
$ az aro list -o table
$ az aro list-credentials -c <cluster_name> -g <resource_group>
```

### Connect to the cluster

Once the installation is complete, cluster access can be obtained using the downloaded VPN configuration file in the `101-azure-vnet-std` subdirectory or by using the check-vpn script as follows:
```
$ cd /workspace/current/105-azure-aro-std/
$ ../check-vpn.sh
```
The cluster access can then be obtained using the kubeconfig file as follows:
```
$ cd /workspace/current/105-azure-aro-std/
$ export KUBECONFIG="./.kube/config"
$ oc get nodes
```
this should list the configured nodes on the cluster if the VPN is functioning.
