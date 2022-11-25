#!/bin/bash

# IBM Ecosystem Labs

SCRIPT_DIR="$(cd $(dirname $0); pwd -P)"
SRC_DIR="${SCRIPT_DIR}"

DOCKER_IMAGE="quay.io/cloudnativetoolkit/cli-tools-azure:v1.2-v0.6.0"

SUFFIX=$(echo $(basename ${SCRIPT_DIR}) | base64 | sed -E "s/[^a-zA-Z0-9_.-]//g" | sed -E "s/.*(.{5})/\1/g")
CONTAINER_NAME="cli-tools-${SUFFIX}"

echo "Cleaning up old container: ${CONTAINER_NAME}"

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

if [[ "${SETUP^}" == "Y" ]] || [[ -z $SETUP ]]; then
  echo "Initializing container ${CONTAINER_NAME} from ${DOCKER_IMAGE} and setting up environment"
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v ${SRC_DIR}:/terraform \
    -v workspace:/workspaces \
    ${ENV_FILE} \
    -w /workspaces/current \
    ${DOCKER_IMAGE}

    ${DOCKER_CMD} exec -ti ${CONTAINER_NAME} sh -c "cd /terraform && /terraform/setup-workspace.sh -i"

    echo
    echo "Attaching to running container..."
    echo "Changing to work directory..."
    echo "Run ./apply-all.sh -a to start build."
else
  echo "Initializing container ${CONTAINER_NAME} from ${DOCKER_IMAGE}"
  ${DOCKER_CMD} run -itd --name ${CONTAINER_NAME} \
    --device /dev/net/tun --cap-add=NET_ADMIN \
    -v ${SRC_DIR}:/terraform \
    -v workspace:/workspaces \
    ${ENV_FILE} \
    -w /terraform \
    ${DOCKER_IMAGE}
  echo "Attaching to running container..."
fi

${DOCKER_CMD} attach ${CONTAINER_NAME}
