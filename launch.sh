#!/bin/bash

# IBM Ecosystem Labs

SCRIPT_DIR="$(cd $(dirname $0); pwd -P)"
SRC_DIR="${SCRIPT_DIR}"
STOP_FILE="${SCRIPT_DIR}/.stop"

DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools-azure:v1.2-v0.6.0"

SUFFIX=$(echo $(basename ${SCRIPT_DIR}) | base64 | sed -E "s/[^a-zA-Z0-9_.-]//g" | sed -E "s/.*(.{5})/\1/g")
CONTAINER_NAME="cli-tools-${SUFFIX}"

echo "Cleaning up old container: ${CONTAINER_NAME}"

# Clean up stop file if it exists (this is used for flow control with container)
if [[ -e $STOP_FILE ]]; then
  rm -f $STOP_FILE
fi

DOCKER_CMD="docker"
${DOCKER_CMD} kill ${CONTAINER_NAME} 1> /dev/null 2> /dev/null
${DOCKER_CMD} rm ${CONTAINER_NAME} 1> /dev/null 2> /dev/null

if [[ -n "$1" ]]; then
    echo "Pulling container image: ${DOCKER_IMAGE}"
    ${DOCKER_CMD} pull "${DOCKER_IMAGE}"
fi

ENV_FILE=""
if [[ -f "credentials.properties" ]]; then
  ENV_FILE="--env-file credentials.properties"
fi

echo -n "Setup workspace (y/n) [Y]: "
read SETUP
echo

  echo "Initializing container ${CONTAINER_NAME} from ${DOCKER_IMAGE} and setting up environment"
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v ${SRC_DIR}:/terraform \
    -v workspace:/workspaces \
    -w /terraform \
    ${ENV_FILE} \
    ${DOCKER_IMAGE}

if [[ "${SETUP^}" == "Y" ]] || [[ -z $SETUP ]]; then

    # Check if service principal details provided, if not login to Azure CLI
    echo "Checking credentials & logging into Azure CLI"
    ${DOCKER_CMD} exec -it -w /terraform ${CONTAINER_NAME} sh -c "/terraform/az-login.sh"

    if [[ -e $STOP_FILE ]]; then
      rm -f $STOP_FILE
      exit 1;
    fi
    
    ${DOCKER_CMD} exec -it -w /terraform ${CONTAINER_NAME} sh -c "cd /terraform ; /terraform/setup-workspace.sh -i" 

    if [[ -e $STOP_FILE ]]; then
      rm -f $STOP_FILE
      exit 1;
    fi

    echo -n "Build environment (only yes will be accepted) : "
    read BUILD

    if [[ "${BUILD^^}" == "YES" ]]; then
      ${DOCKER_CMD} exec -it -w /workspaces/current ${CONTAINER_NAME} sh -c "./apply-all.sh -a"
    else
      echo
      echo "Attaching to running container..."
      echo
      echo "Run \"cd /workspaces/current && ./apply-all.sh -a\" to start build."
    fi
else
    echo "Attaching to running container..."
fi

${DOCKER_CMD} attach ${CONTAINER_NAME}
