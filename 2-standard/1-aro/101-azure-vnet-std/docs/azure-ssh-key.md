# Azure SSH Key

## Module overview

### Description

This module stores a public key into the Azure vault. If a key is not passed to the module, a new key pair is created and stored in the current working directory.

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - https://www.terraform.io/docs/language/modules/develop/providers.html. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly.

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15

#### Terraform providers

- Azure provider >= 2.91.0

### Module dependencies

This module makes use of the output from other modules:

- Azure resource group - github.com/cloud-native-toolkit/terraform-azure-resource-group >= 1.0.2

### Example usage

```hcl-terraform
module "ssh_key" {
    source = "github.com/cloud-native-toolkit/terraform-azure-ssh-key"

    key_name = "test-key"
    resource_group_name = module.resource_group.name
    region= module.resource_group.region
    store_path = "${path.cwd}/${var.path_offset}"
  
}
```

## Variables

### Inputs

This module has the following input variables:
| Variable | Mandatory / Optional | Default Value | Description |
| -------------------------------- | --------------| ------------------ | ----------------------------------------------------------------------------- |
| key_name | Optional | "" | Name to give to the SSH key |
| name_prefix | Optional | "" | Prefix for the SSH key. If neither key_name nor name_prefix are provided, a random name is assigned. |
| resource_group_name | Optional | "" | Name of the resource group if storing the SSH key in the Azure vault |
| region | Optional | "" | Azure location if storing the SSH key in the Azure vault. |
| store_path | Optional | CWD | Path offset from current working directory (CWD) to store keys. |
| public_file_permissions | Optional | 0600 | Permissions for created public key file |
| private_file_permissions | Optional | 0400 | Permissions for created private key file |
| store_key_in_vault | Optional | true | Flag to specify whether to store generated keys in Azure vault |
| ssh_key | Optional | "" | Path to existing public key to used |
| algorithm | Optional | RSA | Encryption algorithm to be used (RSA, ECDSA or ED25519) |
| rsa_bits | Optional | 4096 | Number of bits if using RSA encryption |
| ecdsa_curve | Optional | P224 | Curve to use if using ECDSA |
| tags | Optional | "" | Extra tags to be added to the Azure vault entry. |

### Outputs

The module outputs the following values:
| Output | Description |
| -------------------------------- | -------------------------------------------------------------------------- |
| id | The Id of the Azure vault entry if created |
| pub_key | The public key |
| pub_key_file | Filename of the public key |
| private_key | The private key (sensitive) |
| private_key_file | Filename of the private key |
| path | Path to the keys |
| name | Name of the created key set |