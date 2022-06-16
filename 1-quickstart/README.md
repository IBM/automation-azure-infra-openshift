# Azure Quick Start Reference Architecture

Automation to provision the Quick Start reference architecture on Azure. This architecture implements the minimum infrastructure required to stand up a managed Red Hat OpenShift cluster with public endpoints.

## Reference Architecture

![QuickStart](architecture.png)

The automation is delivered in a number of layers that are applied in order. Layer `110` provisions the infrastructure including the Red Hat OpenShift cluster and the remaining layers provide configuration inside the cluster. Each layer depends on resources provided in the layer before it (e.g. `200` depends on `110`). Where two layers have the same numbers (e.g. `205`), you have a choice of which layer to apply.


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
<td>105 - IBM VPC OpenShift</td>
<td>This layer provisions the bulk of the Azure infrastructure and OpenShift</td>
<td>
<h4>Network</h4>
<ul>
<li>Virtual network</li>
<li>VNet Master and Worker Subnets</li>
<li>Network Security Group</li>
<li>Inbound and outbound Load Balancer</li>
<li>Red Hat OpenShift cluster</li>
</ul>
</td>
</tr>
<tr>
<td>110 - Azure Acme Certificate</td>
<td>This layer replaces the self-signed certificates with auto-generated ones from Acme & LetsEncrypt. This allows web browser console access to the cluster. Note that this layer invalidates the access key in the existing kubeconfig. It is necessary to get a new access key from the console to login at the command line after applying this layer.</td>
<td>
<h4>Network</h4>
<ul>
<li>API Certificate</li>
<li>Apps certificate</li>
<li>Certificate Issuer CA</li>
<li>OpenShift Cluster Update</li>
</ul>
</td>
</tr>
</tbody>
</table>

## Automation

### Prerequisites

1. Access to an Azure account with "Owner" and "User Access Administrator" roles in an Azure Subscription. The user must be able to create a service principal per the below prerequisite.

2. Install [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
    This is required to setup the service principal per the below instructions, not to deploy OpenShift. So if you already have a service principal or create the service principal via the Azure portal, than the Azure CLI is not required.

3. [Configure Azure DNS](https://github.com/openshift/installer/blob/d0f7654bc4a0cf73392371962aef68cd9552b5dd/docs/user/azure/dnszone.md).
   1. Buy or have an existing domain
   1. Decide on a subdomain of the existing domain (for example ocp.azure)
   1. Create a new resource group in your Azure subscription
   1. Create a DNS zone in the Azure resource group using the subdomain and existing domain (for example, ocp.azure.example.com)
   1. Once crated, go to your domain provider and delegate access for the new subdomain to Azure domain name servers provided in the Azure DNS zone. Note that the TTL should match. 

    Azure DNS Zone
    ![azure-dns-zone](azure-dns-zone.png)

    Domain Provider Delegation
    ![domain-delegation](domain-delegation.png)

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

    1. Assign Contributor and User Access Administrator roles to the service principal if not already in place.
        ```shell
        az role assignment create --role "User Access Administrator" --assignee-object-id $(az ad sp list --filter "appId eq '$CLIENT_ID'" | jq '.[0].id' -r)
        ```
        where $CLIENT_ID is the appId of the service principal created in the prior step.

5. Get your [OpenShift installer pull secret](https://console.redhat.com/openshift/install/pull-secret) and save it in `./pull-secret`.

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

4. Run **./launch.sh**. This will start a container image with the prompt opened in the `/terraform` directory, pointed to the repo directory.
5. Create a working copy of the terraform by running **./setup-workspace.sh**. The script makes a copy of the terraform in `/workspaces/current` and set up a "terraform.tfvars" file populated with default values. The **setup-workspace.sh** script has a number of optional arguments.

    ```
    Usage: setup-workspace.sh [-s STORAGE] [-r REGION] [-n PREFIX_NAME]
    
    where:
      - **STORAGE** - The storage provider. Possible options are `portworx` or `odf`. If not provided as an argument, a prompt will be shown.
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
./apply-all.sh
```

The script will run through each of the terraform layers in sequence to provision the entire infrastructure.

#### Run all the terraform layers manually

From the **/workspace/current** directory, change directory into each of the layer subdirectories and run the following:

```shell
terragrunt init
terragrunt apply -auto-approve
```

### Obtain login information

Once the "105-azure-ocp-ipi" BOM (and optionally the 110-azure-acme-certificate BOM) has successfully run it is possible to obtain the login information by running from the **/workspace/current** directory:
```shell
./show-login.sh
```

