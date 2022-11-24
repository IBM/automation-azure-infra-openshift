#/bin/bash

# Add check that cluster has been built

WORK_DIR="/workspaces/current"
ACME_DIR="110-azure-acme-certificate"

cd $WORK_DIR

OCP_DIR=$(cat layers.yaml | grep names_105 | awk '{printf $2}' | sed 's/\"//g')
PRIVATE=0
if [[ -d $OCP_DIR ]]; then
    if [[ -n $(echo $OCP_DIR | grep aro) ]]; then # ARO
        BIN_DIR="${WORK_DIR}/bin"
        SERVER_URL=$(cat ${WORK_DIR}/${OCP_DIR}/.tmp/aro/output.json | ${BIN_DIR}/jq -r '.result.properties.apiserverProfile.url')
        CONSOLE_URL=$(cat ${WORK_DIR}/${OCP_DIR}/.tmp/aro/output.json | ${BIN_DIR}/jq -r '.consoleUrl')
        USERNAME=$(cat ${WORK_DIR}/${OCP_DIR}/.tmp/aro/credentials.json | ${BIN_DIR}/jq -r '.kubeadminUsername')
        PASSWORD=$(cat ${WORK_DIR}/${OCP_DIR}/.tmp/aro/credentials.json | ${BIN_DIR}/jq -r '.kubeadminPassword')
        if [[ $(cat ${WORK_DIR}/${OCP_DIR}/.tmp/aro/output.json | ${BIN_DIR}/jq -r '.result.properties.apiserverProfile.visibility') -eq "Private" ]]; then
            PRIVATE=1
        fi
    else   # IPI
        cd $OCP_DIR
        SERVER_URL=$(terragrunt output -raw server_url )
        USERNAME=$(terragrunt output -raw username )
        PASSWORD=$(terragrunt output -raw password )
        BIN_DIR=$(terragrunt output -raw bin_dir )
        CONSOLE_URL=$(terragrunt output -raw consoleURL )
    fi
else
    echo "ERROR: Openshift directory $OCP_DIR not found."
    exit 1;
fi

OVPN_FILE=$(find "${WORK_DIR}" -name "*.ovpn" | head -1)

echo "To login via command line:"
cd $WORK_DIR
if [[ -d $ACME_DIR ]]; then
    cd $ACME_DIR
    if [ "$(terragrunt output -raw ca_cert)" == "" ]; then
        echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD"
    else
        CA_CRT="./110-azure-acme-certificate/certs/apps-issuer-ca.crt"
        echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD --certificate-authority=$CA_CRT"
    fi
else
    if [[ $PRIVATE ]]; then
        echo
        echo "Connect to VPN using the client configuration $OVPN_FILE"
        echo "If in container, a quick way is as follows:"
        echo "cd ${WORK_DIR}/200-openshift-gitops && ${WORK_DIR}/check-vpn.sh && cd -"
        echo
    fi
    echo "$BIN_DIR/oc login -s=$SERVER_URL -u=$USERNAME -p=$PASSWORD"
fi

# Show console URL
echo ""
echo "To login to the console (may take a few minutes for certificate to be applied to cluster):"
if [[ $PRIVATE ]]; then
    echo
    echo "Connect to VPN using the client configuration $OVPN_FILE"
    echo "If in container, a quick way is as follows:"
    echo "cd ${WORK_DIR}/200-openshift-gitops && ${WORK_DIR}/check-vpn.sh && cd -"
    echo
fi
echo "Console URL - ${CONSOLE_URL}"
echo "Username    - ${USERNAME}"
echo "Password    - ${PASSWORD}"

