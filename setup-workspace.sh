#!/usr/bin/env bash
# 
# For the interactive portion, the az & yq cli tools must be in the shell path
# and the Azure cli must be logged in
#

SCRIPT_DIR=$(cd $(dirname $0); pwd -P)
METADATA_FILE="${SCRIPT_DIR}/azure-metadata.yaml"

WORKER_TYPE="Standard_D4s_v3"
NODE_QTY="3"

INTERACT=0

function usage()
{
   echo "Creates a workspace folder and populates it with architectures."
   echo
   echo "Usage: setup-workspace.sh -f FLAVOR -s STORAGE -c CERTIFICATE [-n PREFIX_NAME] [-r REGION]"
   echo "  options:"
   echo "  -f     the flavor to use (quickstart, standard)"
   echo "  -d     OpenShift distribution (aro, ipi). IPI is currently only available with quickstart."
   echo "  -s     the storage option to use (portworx or default)"
   echo "  -c     certificate to use (acme or byo) - only applicable for IPI distributions."
   echo "  -z     domain name for IPI distributions"
   echo "  -e     resource grop that contains the DNS zone for IPI distributions."
   echo "  -n     (optional) prefix that should be used for all variables"
   echo "  -r     (optional) the region where the infrastructure will be provisioned"
   echo "  -b     (optional) the banner text that should be shown at the top of the cluster"
   echo "  -g     (optional) the git host that will be used for the gitops repo. If left blank gitea will be used by default. (Github, Github Enterprise, Gitlab, Bitbucket, Azure DevOps, and Gitea servers are supported)"
   echo "  -i     activates interactive mode to input required values"
   echo "  -h     Print this help"
   echo
}

# Get the options
while getopts ":f:d:s:c:z:e:n:r:b:g:hi" option; do
   case $option in
      h) # display Help
         usage
         exit 1;;
      i) # Interactive mode
         INTERACT=1;;
      f) # Enter a flavor
         FLAVOR=$OPTARG;;
      d) # Enter a distribution
         DIST=$OPTARG;;
      s) # Enter a storage option
         STORAGE=$OPTARG;;
      c) # Enter a name
         CERT=$OPTARG;;
      z) # Enter the domain name
         DOMAIN=$OPTARG;;
      e) # Enter the resource group for the DNS zone
         DNS_RESOURCE_GROUP=$OPTARG;;
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
         usage
         exit 1;;
   esac
done

function menu() {
    local item i=1 numItems=$#

    for item in "$@"; do
        printf '%s %s\n' "$((i++))" "$item"
    done >&2

    while :; do
        printf %s "${PS3-#? }" >&2
        read -r input
        if [[ -z $input ]]; then
            break
        elif (( input < 1 )) || (( input > numItems )); then
          echo "Invalid Selection. Enter number next to item." >&2
          continue
        fi
        break
    done

    if [[ -n $input ]]; then
        printf %s "${@: input:1}"
    fi
}

function interact() {
  local DEFAULT_FLAVOR="quickstart"
  local DEFAULT_DIST="aro"
  local DEFAULT_CERT="acme"
  local DEFAULT_STORAGE="default"
  local DEFAULT_NODE_QTY=3
  local DEFAULT_WORKER_TYPE="Standard_D4s_v3"
  local DEFAULT_REGION="australiaeast"
  local DEFAULT_BANNER="$DEFAULT_FLAVOR"
  local MAX_PREFIX_LENGTH=5
  local MAX_BANNER_LENGTH=25

  IFS=$'\n'

  if [[ -z "$(which yq)"  ]]; then
    echo "ERROR: yq not found. yq is required for interactive mode."
    echo "If yq is intalled, please ensure it is included in the PATH environment variable."
    exit 1;
  fi

  if [[ -z "$(which az)" ]]; then
    echo "ERROR: az cli not found. az cli is required for interactive mode."
    echi "If the az cli is installed, please ensure it is included in the PATH environment variable."
    exit 1;
  fi

  # Get flavor
  echo
  read -r -d '' -a FLAVORS < <(yq '.flavors[].name' $METADATA_FILE | sort -u)
  PS3="Select the architecture flavor [$(yq ".flavors[] | select(.code == \"$DEFAULT_FLAVOR\") | .name" $METADATA_FILE)]: "
  flavor=$(menu "${FLAVORS[@]}")
  case $flavor in
    '') FLAVOR="$DEFAULT_FLAVOR"; ;;
     *) FLAVOR="$(yq ".flavors[] | select(.name == \"$flavor\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get disti
  echo
  read -r -d '' -a DISTS < <(yq '.distributions[].name' $METADATA_FILE | sort -u)
  PS3="Select the distribution [$(yq ".distributions[] | select(.code == \"$DEFAULT_DIST\") | .name" $METADATA_FILE)]: "
  dist=$(menu "${DISTS[@]}")
  case $dist in
    '') DIST="$DEFAULT_DIST"; ;;
     *) DIST="$(yq ".distributions[] | select(.name == \"$dist\") | .code" $METADATA_FILE)"; ;;
  esac

  # Validate flavor and distribution
  if [[ "${FLAVOR}" == "standard" ]] && [[ "${DIST}" == "ipi" ]]; then
    echo "Openshift IPI is currently only supported with quickstart architecture. Please choose a different combination."
    exit
  fi

  # Get region
  echo
  read -r -d '' -a AREAS < <(yq '.regions[].area' $METADATA_FILE | sort -u)
  DEFAULT_AREA="$(yq ".regions[] | select(.code == \"$DEFAULT_REGION\") | .area" $METADATA_FILE)"
  PS3="Select the deployment area [$DEFAULT_AREA]: "
  area=$(menu "${AREAS[@]}")
  case $area in
    '') AREA="$DEFAULT_AREA"; ;;
     *) AREA=$area; ;;
  esac

  echo
  read -r -d '' -a REGIONS < <(yq ".regions[] | select(.area == \"${AREA}\") | .name" $METADATA_FILE | sort -u)
  if [[ $AREA != $DEFAULT_AREA ]]; then
	  DEFAULT_REGION="$(yq ".regions[] | select(.name == \"${REGIONS[0]}\") | .code" $METADATA_FILE)"
  fi
  PS3="Select the region within ${AREA} [$(yq ".regions[] | select(.code == \"$DEFAULT_REGION\") | .name" $METADATA_FILE)]: "
  region=$(menu "${REGIONS[@]}")
  case $region in
    '') REGION="$DEFAULT_REGION"; ;;
     *) REGION="$(yq ".regions[] | select(.name == \"$region\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get storage
  echo
  read -r -d '' -a STORAGE_OPTIONS < <(yq '.storage[].name' $METADATA_FILE | sort -u)
  PS3="Select the storage [$(yq ".storage[] | select(.code == \"$DEFAULT_STORAGE\") | .name" $METADATA_FILE)]: "
  storage=$(menu "${STORAGE_OPTIONS[@]}")
  case $storage in
    '') STORAGE="$DEFAULT_STORAGE"; ;;
     *) STORAGE="$(yq ".storage[] | select(.name == \"$storage\") | .code" $METADATA_FILE)"; ;;
  esac

  # Get cert
  if [[ "${DIST}" == "ipi" ]]; then
    echo
    read -r -d '' -a CERT_OPTIONS < <(yq ".cert_options[].name" $METADATA_FILE | sort -u)
    PS3="Select the certificate type [$(yq ".cert_options[] | select(.code == \"$DEFAULT_CERT\") | .name" $METADATA_FILE)] : "
    cert=$(menu "${CERT_OPTIONS[@]}")
    case $cert in
      '') CERT="$DEFAULT_CERT"; ;;
       *) CERT="$(yq ".cert_options[] | select(.name == \"$cert\") | .code" $METADATA_FILE)"; ;;
    esac
  else
    CERT=""
  fi

  # Get domain name (if IPI)
  if [[ "${DIST}" == "ipi" ]]; then
    echo
    read -r -d '' -a DOMAIN_OPTIONS < <(az network dns zone list -o json --query [].name -o tsv)
    if (( ${#DOMAIN_OPTIONS[@]} == 0 )); then
      echo "ERROR: No DNS zones available in subscription"
      echo "Please create a DNS zone for IPI usage per documentation"
      exit 1
    fi
    PS3="Select the domain for the IPI instance [${DOMAIN_OPTIONS[0]}]: "
    domain=$(menu "${DOMAIN_OPTIONS[@]}")
    case $domain in
      '') DOMAIN="${DOMAIN_OPTIONS[0]}"; ;;
      *) DOMAIN="$domain"; ;;
    esac

    DNS_RESOURCE_GROUP=$(az network dns zone list -o json | jq -r ".[] | select (.name == \"$DOMAIN\") | .resourceGroup")
  fi

  # Get worker node type
  echo
  read -r -d '' -a WORKER_TYPES < <(yq '.worker_types[].name' $METADATA_FILE )
  PS3="Select the worker node type [$DEFAULT_WORKER_TYPE]: "
  type=$(menu "${WORKER_TYPES[@]}")
  case $type in
    '') WORKER_TYPE="$DEFAULT_WORKER_TYPE"; ;;
     *) WORKER_TYPE="$(yq ".worker_types[] | select(.name == \"$type\") | .code" $METADATA_FILE)"; ;;
  esac
  if [[ $WORKER_TYPE == "other" ]]; then
    WORKER_TYPE=""
    while [[ -z $WORKER_TYPE ]]; do
      echo
      echo -n -e "Enter worker type [$DEFAULT_WORKER_TYPE]: "
      read type_input

      if [[ -n $type_input ]]; then
        if [[ ! $type_input =~ [^a-zA-Z0-9_] ]]; then
          WORKER_TYPE=$type_input
        else
          echo "Invalid worker type. Worker types can only contain alphanumeric and underscore characters."
        fi
      elif [[ -z $type_input ]]; then
        WORKER_TYPE="$DEFAULT_WORKER_TYPE"
      fi
    done    
  fi

  # Get number of worker nodes
  while [[ -z $NODES ]]; do
    echo
    echo -n -e "Enter the number of worker nodes [$DEFAULT_NODE_QTY]: "
    read node_qty

    if [[ -n $node_qty ]]; then
      if (( node_qty > 1 )) && (( node_qty <= 60 )); then
        NODES="$node_qty"
      else
        echo "Invalid quantity. Must be between 2 and 60."
      fi
    elif [[ -z $node_qty ]]; then
      NODES="$DEFAULT_NODE_QTY"
    fi
  done
  NODE_QTY="$NODES"

  # Get name prefix
  local name=""
  letter1=abcdefghijklmnopqrstuvwxyz
  chars=abcdefghijklmnopqrstuvwxyz0123456789
  name=${letter1:RANDOM%${#letter1}:1}
  for i in {1..4}; do
      name+=${chars:RANDOM%${#chars}:1}
  done


  while [[ -z $INPUT_NAME ]]; do
    echo
    echo -n -e "Enter name prefix [$name]: "
    read input

    if [[ -n $input ]]; then
      if [[ $input =~ [a-zA-Z0-9] ]] && (( ${#input} <= $MAX_PREFIX_LENGTH )) ; then
        INPUT_NAME=$input
      else
        echo "Invalid prefix name. Must be less than $MAX_PREFIX_LENGTH, not contain spaces and be alphanumeric characters only"
      fi
    elif [[ -z $input ]]; then
      INPUT_NAME=$name
    fi
  done

  if [[ -n $INPUT_NAME ]]; then
    PREFIX_NAME="${INPUT_NAME}"
  else
    PREFIX_NAME="${NAME}"
  fi

  # Get git host
  if [[ $DIST == "ipi" ]]; then
    DEFAULT_GITHOST="github.com"
  else
    DEFAULT_GITHOST="gitea"
  fi
  echo
  read -r -d '' -a GIT_HOST_OPTIONS < <(yq ".git_hosts[].name" $METADATA_FILE)
  PS3="Select GitOps Host Type [$(yq ".git_hosts[] | select(.code == \"$DEFAULT_GITHOST\") | .name" $METADATA_FILE)]: "
  githost=$(menu "${GIT_HOST_OPTIONS[@]}")
  case $githost in
    '') GIT_HOST_CODE="$DEFAULT_GITHOST"; ;;
     *) GIT_HOST_CODE="$(yq ".git_hosts[] | select(.name == \"$githost\") | .code" $METADATA_FILE)"; ;;
  esac

  if [[ -z $GIT_HOST_CODE ]]; then
    GIT_HOST=""
    while [[ -z $GIT_HOST ]]; do
      echo
      echo -n "Please enter hostname for $githost : "
      read hostname

      if [[ -n $hostname ]] && [[ ! $hostname =~ [^a-zA-Z0-9_-.] ]]; then
        GIT_HOST="$hostname"
      else
        echo "Invalid hostname. Please enter a valid hostname for $githost"
      fi
    done
  elif [[ $GIT_HOST_CODE == "gitea" ]]; then
    if [[ $DIST == "ipi" ]]; then
      echo "Gitea is not support with IPI. "
      exit 1
    else
      GIT_HOST=""
    fi
  else
    GIT_HOST=$GIT_HOST_CODE
  fi

  # Get banner
  echo
  echo -n "Enter title for console banner [$DEFAULT_BANNER]: "
  read BANNER_NAME

  if [[ -n $BANNER_NAME ]]; then
    BANNER="${BANNER_NAME}"
  else
    BANNER="${DEFAULT_BANNER}"
  fi

  echo
  echo "Setting up workspace with the following"
  echo "Architecture (Flavor) = $FLAVOR"
  echo "Region/Location       = $REGION"
  echo "Distribution          = $DIST"
  echo "Storage               = $STORAGE"
  echo "Worker Node Flavor    = $WORKER_TYPE"
  echo "Worker Nodes          = $NODE_QTY"
  echo "Name Prefix           = $PREFIX_NAME"
  if [[ $DIST == "ipi" ]]; then
    echo "Ingress Certificate   = $CERT"
    echo "Domain                = $DOMAIN"
  fi
  echo "GitOps Host           = $GIT_HOST"
  echo "Console Banner Title  = $BANNER"

  echo -n "Confirm setup workspace with these settings (Y/N) [Y]: "
  read confirm

  if [[ -z $confirm ]]; then
    confirm="Y"
  fi

  if [[ ${confirm^} != "Y" ]]; then
    echo "Exiting without setting up environment" >&2
    touch ${SCRIPT_DIR}/.stop
    exit 1
  fi

}

if (( $INTERACT != 0 )); then
  interact
fi

if [[ -z "${FLAVOR}" ]]; then
  FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | grep -E "^[0-9]-" | sort | sed -e "s/[0-9]-//g" | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  PS3="Select the flavor: "

  select flavor in ${FLAVORS[@]}; do
    if [[ -n "${flavor}" ]]; then
      FLAVOR="${flavor}"
      break
    fi
  done
  FLAVORS_DIR="${REPLY}-${FLAVOR,,}"
else
  FLAVORS=($(find "${SCRIPT_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/" | sed -E "s~${SCRIPT_DIR}/~~g" | sort | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'))

  for flavor in ${FLAVORS[@]}; do
    if [[ "${flavor,,}" =~ ${FLAVOR} ]]; then
      FLAVORS_DIR="${flavor}"
      break
    fi
  done
fi

## Get distribution and determine full flavor directory
if [[ -z "${DIST}" ]]; then
  DISTS=$(find "${SCRIPT_DIR}/${FLAVORS_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/${FLAVORS_DIR}" | sed -E "s~${SCRIPT_DIR}\/${FLAVORS_DIR}/~~g" | grep -E "^[0-9]-" | sort | sed -e "s/[0-9]-//g" | tr '[:lower:]' '[:upper:]')

  PS3="Select the distribution: "

  select dist in ${DISTS[@]}; do
    if [[ -n "${dist}" ]]; then
      DISTRIBUTION="${dist}"
      break
    fi
  done
  DIST=$(echo "${DISTRIBUTION}" | tr '[:upper:]' '[:lower:]')
  FLAVOR_DIR="${FLAVORS_DIR}/${REPLY}-${DIST}"
else
  DIST_DIRS=$(find "${SCRIPT_DIR}/${FLAVORS_DIR}" -type d -maxdepth 1 | grep "${SCRIPT_DIR}/${FLAVORS_DIR}" | sed -E "s~${SCRIPT_DIR}\/${FLAVORS_DIR}/~~g" | grep -E "^[0-9]-")
  for dist_dir in ${DIST_DIRS[@]}; do
    if [[ "${dist_dir,,}" =~ ${DIST} ]]; then
      FLAVOR_DIR="${FLAVORS_DIR}/${dist_dir}"
      break
    fi
  done
fi

# Validate flavor and distribution
if [[ "${FLAVOR}" == "standard" ]] && [[ "${DIST}" == "ipi" ]]; then
 echo "Openshift IPI is currently only supported with quickstart architecture. Please choose a different combination."
 exit
fi

# Validate region
if [[ -z "$(cat ${METADATA_FILE} | yq ".regions[] | select(.code == \"${REGION}\") | .code" )" ]]; then
  echo "Supplied region ${REGION} is not a valid Azure region for an OpenShift deployment."
  echo "Please select a valid deployment region."
  SELECT_AREA=true
elif [[ -z "${REGION}" ]]; then
  echo "Please select the deployment region."
  SELECT_AREA=true
else
  SELECT_AREA=false
fi

if $SELECT_AREA ; then
  AREAS=$(cat ${METADATA_FILE} | yq '.regions[].area' | tr ' ' '_' | sort -u )
  PS3="Select the deployment area: "
  select area in ${AREAS[@]}; do
    if [[ -n "${area}" ]]; then
      AREA=$(echo ${area} | tr '_' ' ')
      break
    fi
  done

  REGIONS=$(cat ${METADATA_FILE} | yq ".regions[] | select(.area == \"${AREA}\") | .name" | tr ' ' '_')
  PS3="Select the region within ${AREA}: "
  select region in ${REGIONS[@]}; do
    if [[ -n "${region}" ]]; then
      REGION=$(cat ${METADATA_FILE} | yq ".regions[] | select(.name == \"$(echo $region | tr '_' ' ')\") | .code")
      break
    fi
  done
fi

# Get storage option
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

if [[ "${DIST}" == "ipi" ]]; then
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

  if [[ -z $DOMAIN ]]; then
    echo -n "Enter the domain to use: "
    read DOMAIN
  fi

  if [[ -z $DNS_RESOURCE_GROUP ]]; then
    echo -n "Enter the resource group for the DNS zone $DOMAIN: "
    read DNS_RESOURCE_GROUP
  fi
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
else
  letter1=abcdefghijklmnopqrstuvwxyz
  chars=abcdefghijklmnopqrstuvwxyz0123456789
  NAME=${letter1:RANDOM%${#letter1}:1}
  for i in {1..4}; do
      NAME+=${chars:RANDOM%${#chars}:1}
  done
  echo -n "Enter name prefix (default = ${NAME}): "
  read INPUT_NAME
  if [[ -n $INPUT_NAME ]]; then
    PREFIX_NAME="${INPUT_NAME}"
  else
    PREFIX_NAME="${NAME}"
  fi
fi

if [[ -z "${GIT_HOST}" ]]; then
  GITHOST_COMMENT="#"
fi

if [[ -z "${BANNER}" ]]; then
  BANNER="${FLAVOR}"
fi

cat "${SCRIPT_DIR}/terraform.tfvars.template-${FLAVOR,,}-${DIST}" | \
  sed "s/PREFIX/${PREFIX_NAME}/g" | \
  sed "s/BANNER/${BANNER}/g" | \
  sed "s/REGION/${REGION}/g" | \
  sed "s/WORKER/${WORKER_TYPE}/g" | \
  sed "s/NODE_QTY/${NODE_QTY}/g" | \
  sed "s/DOMAIN/${DOMAIN}/g" | \
  sed "s/DNS_RESOURCE_GROUP/${DNS_RESOURCE_GROUP}/g" \
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
cp "${SCRIPT_DIR}/check-vpn.sh" "${WORKSPACE_DIR}/check-vpn.sh"
cp -R "${SCRIPT_DIR}/${FLAVOR_DIR}/.mocks" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/layers.yaml" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/${FLAVOR_DIR}/terragrunt.hcl" "${WORKSPACE_DIR}"
cp "${SCRIPT_DIR}/show-login.sh" "${WORKSPACE_DIR}/show-login.sh"
mkdir -p "${WORKSPACE_DIR}/bin"

echo "Looking for layers in ${SCRIPT_DIR}/${FLAVOR_DIR}"
echo "Cluster Storage: ${STORAGE}"

if [[ "${DIST}" == "ipi" ]]; then
  echo "Ingress certificate: ${CERT}"
fi

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
  if [[ "${DIST}" == "ipi" ]] && [[ "${name}" =~ ^110 ]] && [[ "${name}" != "${CERT}" ]]; then
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

