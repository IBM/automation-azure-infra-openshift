#/bin/bash

# Add check that cluster has been built

cd 105-azure-ocp-ipi
SERVER_URL=$(terragrunt output -raw server_url )
USERNAME=$(terragrunt output -raw username )
PASSWORD=$(terragrunt output -raw password )
BIN_DIR=$(terragrunt output -raw bin_dir )

# Add check if Certificate has been completed

cd ../110-azure-acme-certificate
if [ "$(terragrunt output -raw ca_cert)" == "" ]; then
    echo "To login"
    echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD"
else
    CA_CRT="./110-azure-acme-certificate/certs/apps-issuer-ca.crt"
    echo "To login"
    echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD --certificate-authority=$CA_CRT"
fi


