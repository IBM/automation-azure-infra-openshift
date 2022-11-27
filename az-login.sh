#!/usr/bin/env bash

STOP_FILE="$(pwd)/.stop"

function manageExit() {
    echo
    echo "Stopping login"
    touch $STOP_FILE
    exit 1;
}

trap manageExit INT
trap manageExit TERM

az account show > /dev/null 2>&1
if (( $? != 0 )); then
    if [[ -n $TF_VAR_client_id ]] && [[ -n $TF_VAR_client_secret ]] && [[ -n $TF_VAR_tenant_id ]] && [[ -n $TF_VAR_subscription_id ]]; then
        # Login with service principal details
        az login --service-principal -u "$TF_VAR_client_id" -p "$TF_VAR_client_secret" -t "$TF_VAR_tenant_id" > /dev/null 2>&1
        if (( $? != 0 )); then
            echo "ERROR: Unable to login to service principal. Check supplied details in credentials.properties."
            touch $STOP_FILE
            exit 1
        else
            echo "Successfully logged on with service principal"
        fi
        az account set --subscription "$TF_VAR_subscription_id" > /dev/null 2>&1
        if (( $? != 0 )); then
            echo "ERROR: Unable to use subscription id $TF_VAR_subscription_id. Please check and try agian."
            touch $STOP_FILE
            exit 1
        else
            echo "Successfully changed to subscription : $(az account show -o yaml | yq '.name')"
        fi
    else
        echo "Please login to Azure CLI to continue"
        az login
    fi
else
    echo "Using existing Azure CLI login"
fi

