# 110-azure-acme-certificate

Bill of materials to create new certificates and assign then to an OpenShift 4.x ingress operator. 

The certificates are assigned from [LetsEncrypt](https://letsencrypt.org/) using the [Acme protocol](https://letsencrypt.org/docs/client-options/) to verify domain ownership.

## Prerequisites

This BOM requires an existing OpenShift cluster onto which to apply the generated certificates.

## Usage as part of a overall reference archtiecture

This BOM can be run as part of an overall reference architecture using the apply-all script in the /workspaces directory after setting up the container per the README in the [github repository](https://github.com/IBM/automation-azure-infra-openshift).

## Usage when run separately

Alternately, to run separately or as a BOM at a time, go into the BOM directory. If running as a container, this would be `/workspaces/current/110-azure-acme-certificate` by default. Then run the following (assuming you are using the container approach):
```shell
terragrunt init
terrgraunt apply
```

## Destroy

If destroying independent of the complete reference architecture, run the following (assuming a container approach):
```shell
terragrunt destroy
```

Note that running destroy will remove any created certificates. If you plan on reusing the certificates, be sure to copy them out of the default directory first. To do so using the container approach run the following prior to the destroy:
```shell
cd /workspaces/current/110-azure-acme-certificate
tar cvzf ./saved-certificates.tgz ./certs
```

This assumes that you are using the default certificate directory (certs), adjust accordingly if has been changed.