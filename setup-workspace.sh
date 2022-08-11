#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)

## For now default to quickstart
FLAVOR="quickstart"
STORAGE=""
#PREFIX_NAME=""
REGION="eastus"

Usage()
{
   echo "Creates a workspace folder and populates it with architectures."
   echo
   echo "Usage: setup-workspace.sh -f FLAVOR -s STORAGE -c CERTIFICATE [-n PREFIX_NAME] [-r REGION]"
   echo "  options:"
   echo "  -f     the flavor to use (quickstart, standard, advanced)"
   echo "  -s     the storage option to use (portworx or default)"
   echo "  -c     certificate to use (acme or byo)"
   echo "  -n     (optional) prefix that should be used for all variables"
   echo "  -r     (optional) the region where the infrastructure will be provisioned"
   echo "  -b     (optional) the banner text that should be shown at the top of the cluster"
   echo "  -g     (optional) the git host that will be used for the gitops repo. If left blank gitea will be used by default. (Github, Github Enterprise, Gitlab, Bitbucket, Azure DevOps, and Gitea servers are supported)"
   echo "  -h     Print this help"
   echo
}

# Get the options
while getopts ":f:s:c:n:r:b:g:" option; do
   case $option in
      h) # display Help
         Usage
         exit 1;;
      f) # Enter a name
         FLAVOR=$OPTARG;;
      s) # Enter a name
         STORAGE=$OPTARG;;
      c) # Enter a name
         CERT=$OPTARG;;
      n) # Enter a name
         PREFIX_NAME=$OPTARG;;
      r) # Enter a name
         REGION=$OPTARG;;
      g) # Enter a name
         GIT_HOST=$OPTARG;;
      b) # Enter a name
         BANNER=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         Usage
         exit 1;;
   esac
done


if [[ -z "${FLAVOR}" ]]; then
  FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | grep -E "^[0-9]-" | sort | sed -e "s/[0-9]-//g" | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  PS3="Select the flavor: "

  select flavor in ${FLAVORS[@]}; do
    if [[ -n "${flavor}" ]]; then
      FLAVOR="${flavor}"
      break
    fi
  done

  FLAVOR_DIR="${REPLY}-${FLAVOR,,}"
else
  FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | sort | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  for flavor in ${FLAVORS[@]}; do
    if [[ "${flavor,,}" =~ ${FLAVOR} ]]; then
      FLAVOR_DIR="${flavor}"
      break
    fi
  done
fi

STORAGE_OPTIONS=($(find "${SCRIPT_DIR}/${FLAVOR_DIR}" -type d -maxdepth 1 -name "210-*" | grep "${SCRIPT_DIR}/${FLAVOR_DIR}/" | sed -E "s~${SCRIPT_DIR}/${FLAVOR_DIR}/~~g" | sort))

if [[ -z "${STORAGE}" ]]; then

  PS3="Select the storage: "

  select storage in ${STORAGE_OPTIONS[@]}; do
    if [[ -n "${storage}" ]]; then
      STORAGE="${storage}"
      break
    fi
  done
else
  for storage in ${STORAGE_OPTIONS[@]}; do
    if [[ "${storage}" =~ ${STORAGE} ]]; then
      STORAGE="${storage}"
      break
    fi
  done
fi

CERT_OPTIONS=($(find "${SCRIPT_DIR}/${FLAVOR_DIR}" -maxdepth 1 -type d -name "110-*" | grep "${SCRIPT_DIR}/${FLAVOR_DIR}/" | sed -E "s~${SCRIPT_DIR}/${FLAVOR_DIR}/~~g" | sort))

if [[ -z "${CERT}" ]]; then

  PS3="Select the certificate type: "

  select cert in ${CERT_OPTIONS[@]}; do
    if [[ -n "${cert}" ]]; then
      CERT="${cert}"
      break
    fi
  done
else
  for cert in ${CERT_OPTIONS[@]}; do
    if [[ "${cert}" =~ ${CERT} ]]; then
      CERT="${cert}"
      break
    fi
  done
fi

WORKSPACES_DIR="${SCRIPT_DIR}/../workspaces"
WORKSPACE_DIR="${WORKSPACES_DIR}/current"

if [[ -d "${WORKSPACE_DIR}" ]]; then
  DATE=$(date "+%Y%m%d%H%M")
  mv "${WORKSPACE_DIR}" "${WORKSPACES_DIR}/workspace-${DATE}"
fi

mkdir -p "${WORKSPACE_DIR}"

WORKSPACE_DIR=$(cd "${WORKSPACE_DIR}"; pwd -P)

cd "${WORKSPACE_DIR}"

echo "Setting up workspace for ${FLAVOR} in ${WORKSPACE_DIR}"
echo "*****"

if [[ -n "${PREFIX_NAME}" ]]; then
  PREFIX_NAME="${PREFIX_NAME}"
fi

if [[ -z "${GIT_HOST}" ]]; then
  GITHOST_COMMENT="#"
fi

if [[ -z "${BANNER}" ]]; then
  BANNER="${FLAVOR}"
fi

cat "${SCRIPT_DIR}/terraform.tfvars.template-${FLAVOR,,}" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/BANNER/${BANNER}/g" | \
  sed "s/REGION/${REGION}/g" \
  > "${WORKSPACE_DIR}/cluster.tfvars"

if [[ ! -f "${WORKSPACE_DIR}/gitops.tfvars" ]]; then
  cat "${SCRIPT_DIR}/terraform.tfvars.template-gitops" | \
    sed -E "s/#(.*=\"GIT_HOST\")/${GITHOST_COMMENT}\1/g" | \
    sed "s/PREFIX/${PREFIX_NAME}/g"  | \
    sed "s/GIT_HOST/${GIT_HOST}/g" | \
    sed "s/FLAVOR/${FLAVOR}/g" \
    > "${WORKSPACE_DIR}/gitops.tfvars"
fi

cp "${SCRIPT_DIR}/apply-all.sh" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/plan-all.sh" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/destroy-all.sh" "${WORKSPACE_DIR}"
# cp "${SCRIPT_DIR}/check-vpn.sh" "${WORKSPACE_DIR}/check-vpn.sh"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/.mocks" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/layers.yaml" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/terragrunt.hcl" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/show-login.sh" "${WORKSPACE_DIR}/show-login.sh"
mkdir -p "${WORKSPACE_DIR}/bin"

echo "Looking for layers in ${SCRIPT_DIR}/${FLAVOR_DIR}"
echo "Cluster Storage: ${STORAGE}"
echo "Ingress certificate: ${CERT}"

find "${SCRIPT_DIR}/${FLAVOR_DIR}" -type d -maxdepth 1 | grep -vE "[.][.]/[.].*" | grep -v workspace | sort | \
  while read dir;
do

  name=$(echo "$dir" | sed -E "s/.*\///")

  if [[ ! -f "${SCRIPT_DIR}/${FLAVOR_DIR}/${name}/main.tf" ]]; then
    continue
  fi

  # Following ensures only the selected storage type is setup
  if [[ "${name}" =~ ^210 ]] && [[ "${name}" != "${STORAGE}" ]]; then
    continue
  fi

  # Following ensures only the selected certificate type is setup
  if [[ "${name}" =~ ^110 ]] && [[ "${name}" != "${CERT}" ]]; then
    continue
  fi

  echo "Setting up current/${name} from ${name}"

  mkdir -p ${name}
  cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/${name}/"* "${name}"
  cp -f "${SCRIPT_DIR}/apply.sh" "${name}/apply.sh"
  cp -f "${SCRIPT_DIR}/destroy.sh" "${name}/destroy.sh"

  (cd "${name}" && ln -s ../bin bin2)

done

echo "move to ${WORKSPACE_DIR} this is where your automation is configured"
