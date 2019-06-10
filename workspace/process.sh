#!/usr/bin/env bash

export TF_DIR="${1:-../terraforming-azure/terraforming-pas}"

function opsman_vars() {
  export OPS_MANAGER_STORAGE_ACCOUNT="$(terraform output ops_manager_storage_account)"
  export OPS_MANAGER_DNS="$(terraform output ops_manager_dns)"
  export OPS_MANAGER_PUBLIC_IP="$(terraform output ops_manager_ip)"
  export OPS_MANAGER_PRIVATE_IP="$(terraform output ops_manager_private_ip)"
  export OPS_MANAGER_PUBLIC_IP="$(terraform output ops_manager_public_ip)"
  export OPS_MANAGER_SECURITY_GROUP_NAME="$(terraform output ops_manager_security_group_name)"
  export OPS_MANAGER_SSH_PRIVATE_KEY="$(terraform output ops_manager_ssh_private_key)"
  export OPS_MANAGER_SSH_PUBLIC_KEY="$(terraform output ops_manager_ssh_public_key)"
  export OPS_MANAGER_RESOURCE_GROUP="$(terraform output pcf_resource_group_name)"
  export OPS_MANAGER_NETWORK_NAME="$(terraform output network_name)"
  export OPS_MANAGER_SUBNET_NAME="$(terraform output -json infrastructure_subnets| jq -r '.[0]')"
}

# CLIENT_ID=""
# CLIENT_SECRET=""
# DNS_SUBDOMAIN=""
# DNS_SUFFIX=""
# ENV_NAME=""
# LOCATION=""
# OPS_MANAGER_IMAGE_URI=""
# SUBSCRIPTION_ID=""
# TENANT_ID=""
function export_tfvars() {
  tfvars=$1

  IFS==
  while read -r f1 f2; do
    if [[ "$f1" != "" && "${f1:0:1}" != "#"  ]]; then
      export "$(echo ${f1^^} | xargs)"="$(echo $f2 | xargs)"
    fi
  done <$tfvars
}

pushd "${TF_DIR}" > /dev/null
opsman_vars
export_tfvars "terraform.tfvars"
popd > /dev/null

rm -f vars.yml temp.yml
( echo "cat <<EOF >opsman.yml";
  cat template.yml;
  echo -e "\nEOF"
) >temp.yml
. temp.yml
sed -i '' s/\"//g opsman.yml
cat opsman.yml