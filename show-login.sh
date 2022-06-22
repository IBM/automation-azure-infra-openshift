#/bin/bash

# Add check that cluster has been built

cd 105-azure-ocp-ipi
SERVER_URL=$(terragrunt output -raw server_url )
USERNAME=$(terragrunt output -raw username )
PASSWORD=$(terragrunt output -raw password )
BIN_DIR=$(terragrunt output -raw bin_dir )
CONSOLE_URL=$(terragrunt output -raw consoleURL )

# Add check if Certificate has been completed

cd ../110-azure-acme-certificate
echo "To login via command line:"
if [ "$(terragrunt output -raw ca_cert)" == "" ]; then
    echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD"
else
    CA_CRT="./110-azure-acme-certificate/certs/apps-issuer-ca.crt"
    echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD --certificate-authority=$CA_CRT"
fi

# Show console URL
echo ""
echo "To login to the console (may take a few minutes for certificate to be applied to cluster):"
echo "Console URL - ${CONSOLE_URL}"
echo "Username    - ${USERNAME}"
echo "Password    - ${PASSWORD}"

