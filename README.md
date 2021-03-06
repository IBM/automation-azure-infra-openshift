# Azure Reference Architecture - Automation

> This collection of Azure terraform automation bundles has been crafted from a set of [Terraform modules](https://modules.cloudnativetoolkit.dev/) created by the IBM Ecosystem Labs team part of the [IBM Ecosystem organization](https://www.ibm.com/partnerworld/public?mhsrc=ibmsearch_a&mhq=partnerworld). Please contact **Matthew Perrins** __mjperrin@us.ibm.com__, **Rich Ehrhardt** __rich_ehrhardt@au1.ibm.com__, **Sean Sundberg** __seansund@us.ibm.com__, or **Andrew Trice** __amtrice@us.ibm.com__ for more details or raise an issue on the [repository](https://github.com/cloud-native-toolkit/software-everywhere) for bugs or feature requests.

Three different flavors of the reference architecture are provided with different levels of complexity.

- QuickStart - minimum to get OpenShift with public endpoints running on basic VNet, subnets and load balancer. Best for non-production workloads.
- Standard - a simple robust architecture that can support a production workload in a single VNet with a VPN+Private Endpoints and an OpenShift cluster
- Advanced - a sophisticated architecture isolating DMZs, Development and Production VNets for best practices

## Reference architectures

This set of automation packages was generated using the open-source [`isacable`](https://github.com/cloud-native-toolkit/iascable) tool. This tool enables a [Bill of Material yaml](https://github.com/cloud-native-toolkit/automation-solutions/tree/main/boms) file to describe your Azure architecture, which it then generates the terraform modules into a package of infrastructure as code that you can use to accelerate the configuration of your Azure environment. Iascable generates standard terraform templates that can be executed from any terraform environment.

> The `iascable` tool is targeted for use by advanced SRE developers. It requires deep knowledge of how the modules plug together into a customized architecture. This repository is a fully tested output from that tool. This makes it ready to consume for projects.

### Quick Start

![QuickStart](1-quickstart/architecture.png)

### Standard

TBD

### Advanced

TBD

## Automation

### Prerequisites

1. Have access to an Azure subscription with "Owner" and "User Access Administrator" roles. The user must be able to create a service prinicpal.

2. Configure an Azure DNS zone with a valid public domain (refer to the README [here](1-quickstart/README.md) for more information)

3. Create a service principal to be used to create the cluster (refer to the README [here](1-quickstart/README.md) for more information)

4. Obtain a Red Hat [OpenShift installer pull secret](https://console.redhat.com/openshift/install/pull-secret)

5. (Optional) Install and start Colima to run the terraform tools in a local bootstrapped container image.

    On Mac with brew (note that this only works with Intel based Macs at this time):
    ```shell
    brew install docker colima
    colima start
    ```

### Planning

1. Determine which flavor of reference architecture you will provision: Quick Start, Standard, or Advanced.
2. View the README in the automation directory for detailed instructions for installation steps and required information:
    - [Quick Start](1-quickstart)
    - [Standard](2-standard)
    - [Advanced](3-advanced)

### Setup

1. Clone this repository to your local SRE laptop or into a secure terminal. Open a shell into the cloned directory.
2. Copy **credentials.template** to **credentials.properties**.
    ```shell
    cp credentials.template credentials.properties
    ```
3. Provide values for the variables in **credentials.properties** (**Note:** `*.properties` has been added to **.gitignore** to ensure that the file containing the apikey cannot be checked into Git.)
    - **TF_VAR_subscription_id** - The Azure subscription id where the cluster will be deployed
    - **TF_VAR_tenant_id** - The Azure tenant id that owns the subscription
    - **TF_VAR_client_id** - The id of the service principal with Owner and User Administrator access to the subscription for cluster creation
    - **TF_VAR_client_secret** - The password of the service principal with Owner and User Administrator access to the subscription for cluster creation
    - **TF_VAR_pull_secret** - The contents of the Red Hat OpenShift pull secret
    - **TF_VAR_acme_registration_email** - (Optional) If using an auto-generated ingress certificate, this is the email address with which to register the certificate with LetsEncrypt.
    - **TF_VAR_testing** - This value is used to determine whether testing or staging variables should be utilised. Lease as `none` for production deployments. A value other than `none` will request in a non-production deployment.
    - **TF_VAR_portworx_spec** - A base64 encoded string of the Portworx specificatin yaml file. If left blank and using Portworx, ensure you specify the path to the Portworx specification yaml file in the `terraform.tfvars` file. For a Portworx implementation, either the `portworx_spec` or the `portworx_spec_file` values must be specified. If neither if specified, Portworx will not implement correctly.
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
7. Inspect **terraform.tfvars** to see if there are any variables that should be changed. (The **setup-workspace.sh** script has generated **terraform.tfvars** with default values. At a minimum, modify the ***base_domain_name*** and ***resource_group_name*** values to suit the Azure DNS zone configured in the prerequisite steps.)

    **Note:** A soft link has been created to the **terraform.tfvars** in each of the terraform subdirectories so the configuration is shared between all of them. 

#### Run all the terraform layers automatically

From the **/workspace/current** directory, run the following:

```
./apply-all.sh
```

The script will run through each of the terraform layers in sequence to provision the entire infrastructure.

#### Run all the terraform layers manually

From the **/workspace/current** directory, run change directory into each of the layer subdirectories and run the following:

```shell
terragrunt init
terragrunt apply -auto-approve
```

### Obtain login information

Once the "105-azure-ocp-ipi" BOM (and optionally the 110-azure-acme-certificate BOM) has successfully run it is possible to obtain the login information by running from the **/workspace/current** directory:
```shell
./show-login.sh
```

<mark>Important:</mark>It may take several minutes for the certificates to be applied to the cluster. If you get a certificate warning when attempting to access the console through a web browser, wait 5 minutes and try again.

### Troubleshooting

#### Cluster installation log

The cluster install log can be found in the install directory (by default `105-azure-ocp-ipi/install/`) in a file called `.openshift-install.log`. 

#### Cluster installation failure

To clean up an failed cluster installation, perform the following steps from the Azure portal:

1. Remove the CNAME and A records from the DNS Zone in the domain resource group. Depending upon when the cluster install failed, there will be only the CNAME for `api.<cluster_name>` or this and the A record for `*.apps.<cluster_name>`
1. Remove the resource group containing the failed OpenShift cluster. Navigate to the resource group (`Home -> Resource groups -> <resource-group-name>`). Note that the resource group name will have a random number appended to the cluster name. For example, if the cluster name were `failed-qs`, then the resource group name would `failed-qs-<5_digit_random>-rg`. Then select the `Delete resource group` button at the top and enter the resource group name as instructed, then click delete at the bottom.

#### Certificates not applied

If after more than 10 minutes, the certificates have not been applied to the default ingress route, check the certificate in the browser to confirm whether it is receiving the new certificate or not. If not, investigate the following:

1. Check that the certificates were successfully applied
Review the terraform status in the `110-azure-<type>-certificate` folder:
```shell
terraform state list | grep set_certs
module.api-certs.null_resource.set_certs
```

Some additional diagnostics can be done by investigating the cluster itself for the changes. After logging into the cluster,

1. Check that the custom-ca configmap has been created
```shell
oc get configmap custom-ca -n openshift-config
NAME        DATA   AGE
custom-ca   1      17h
```

1. Check that the TLS secret has been added
```shell
oc get secret default-ingress-tls -n openshift-ingress
NAME                  TYPE                DATA   AGE
default-ingress-tls   kubernetes.io/tls   2      17h
```
