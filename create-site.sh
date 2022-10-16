#!/bin/bash
#

git fetch

function is_in_local() {
    local branch=${1}
    local existed_in_local=$(git branch --list ${branch})

    if [[ -z ${existed_in_local} ]]; then
        echo 0
    else
        echo 1
    fi
}

function is_in_remote() {
    local branch=${1}
    local existed_in_remote=$(git ls-remote --heads origin ${branch})

    if [[ -z ${existed_in_remote} ]]; then
        echo 0
    else
        echo 1
    fi
}

currentbranch=`git branch --show-current`
echo "current branch = $currentbranch"

if [[ ${currentbranch} == "main" ]]; then
  # in main configure site
  read -p "Site Name: " sitename
  if [ ! "${sitename}" ]; then echo "Error: no sitename provided" ;exit; fi
  if [[ `is_in_local ${sitename}` == 1 ]]; then
    git switch ${sitename} && jq -r ".sitename = \"${sitename}\" " manifests/site.json | sponge manifests/site.json && git add manifests/site.json && git commit --quiet -m "configuring site manifest"
    git merge main -m "Merge master"
  elif [[ `is_in_remote ${sitename}` == 1 ]]; then
    git switch -c ${sitename} origin/${sitename} && jq -r ".sitename = \"${sitename}\" " manifests/site.json | sponge manifests/site.json && git add manifests/site.json && git commit --quiet -m "configuring site manifest"
    git merge main -m "Merge master"
  else
    git checkout -b ${sitename} && jq -r ".sitename = \"${sitename}\" " manifests/site.json | sponge manifests/site.json && git add manifests/site.json && git commit --quiet -m "configuring site manifest"
  fi
  currentbranch=`git branch --show-current`
else
  # reconfiguring a site
  currentbranch=`git branch --show-current`
  read -p "Site Name: [${currentbranch}] " sitename
  sitename="${sitename:=${currentbranch}}"
  if [[ ${currentbranch} != ${sitename} ]]; then
    if [[ `is_in_local ${sitename}` == 1 ]]; then
      git switch ${sitename} && jq -r ".sitename = \"${sitename}\" " manifests/site.json | sponge manifests/site.json && git add manifests/site.json && git commit --quiet -m "configuring site manifest"
    else
      git checkout -b ${sitename} && jq -r ".sitename = \"${sitename}\" " manifests/site.json | sponge manifests/site.json && git add manifests/site.json && git commit --quiet -m "configuring site manifest"
    fi
    currentbranch=`git branch --show-current`
  fi
fi

sitename=$currentbranch

timeout () {
    tput sc
    time=$1; while [ $time -ge 0 ]; do
        tput rc; tput el
        printf "$2" $time
        ((time--))
        sleep 1
    done
    tput rc; tput ed;
}

cd manifests/


echo "# Set up tenant name and check for credentials"
currenttenantname=`jq -r ".tenantname" site.json`
read -p "Tenant Name:: [${currenttenantname}] " tenantname
tenantname="${tenantname:=${currenttenantname}}"

echo "checking for p12 cert"
openssl pkcs12 -in ~/${tenantname}.console.ves.volterra.io.api-creds.p12 -nodes -nokeys -out ~/vescred.cert
openssl pkcs12 -in ~/${tenantname}.console.ves.volterra.io.api-creds.p12 -nodes -nocerts -out ~/vesprivate.key

cat <<EOF > ~/.vesconfig
server-urls: https://${tenantname}.console.ves.volterra.io/api
key: $HOME/vesprivate.key
cert: $HOME/vescred.cert
EOF

read -s -p "CE node new password: " newpassword
if [ ! "${newpassword}" ]; then exit; fi
echo "*********************"

echo "# Change the CE password"
cenodeaddress=`jq -r ".cenodeaddress" site.json`
cenodeport=`jq -r ".cenodeport" site.json`
curl -sS -k -v "https://${cenodeaddress}:${cenodeport}/api/ves.io.vpm/introspect/write/ves.io.vpm.node/change-password" \
  -H 'Authorization: Basic YWRtaW46Vm9sdGVycmExMjM=' \
  -H 'Accept: application/json, text/plain, */*' \
  -H 'Content-Type: application/json' \
  --data-raw "{\"current_password\":\"Volterra123\",\"new_password\":\"${newpassword}\",\"username\":\"admin\"}"
basicauth=`echo -n admin:${newpassword} | base64`
unset newpassword

read -s -p "ArgoCD password: " argocdpassword
echo "*********************"
if [ ! "${argocdpassword}" ]; then exit; fi

vesctl request secrets get-public-key > f5-amer-ent-public-key.key
vesctl request secrets get-policy-document --namespace shared --name ves-io-allow-volterra > secret-policy-ves-io-allow-volterra.crt
echo -n ${argocdpassword} > password.key
unset argocdpassword
encryptedpassword=`vesctl request secrets encrypt --policy-document secret-policy-ves-io-allow-volterra.crt --public-key f5-amer-ent-public-key.key password.key | grep "=$"`

rm password.key f5-amer-ent-public-key.key secret-policy-ves-io-allow-volterra.crt

echo "# Create manifests"

echo "# Create a k8s cluster object"
jq -r ".spec.cluster_wide_app_list.cluster_wide_apps[].argo_cd.local_domain.password.blindfold_secret_info.location = \"string:///${encryptedpassword}\" " k8s_cluster.json | sponge k8s_cluster.json
unset encryptedpassword

vesctl configuration apply k8s_cluster -i k8s_cluster.json
git restore k8s_cluster.json

echo "# Create an appstack site"
vesctl configuration apply voltstack_site -i appstack_site.json

echo "# Create a site token for registration"
vesctl configuration apply token -i token.json
timeout 10 "# Wait for token creation %s"
token=`vesctl configuration get token ${sitename}-token --outfmt json -n system | jq -r ".system_metadata.uid"`

echo "# Register the CE"
jq -r ".token = \"${token}\" " ce-register.json | sponge ce-register.json
curl -sS -k -v "https://${cenodeaddress}:${cenodeport}/api/ves.io.vpm/introspect/write/ves.io.vpm.config/update" \
  -H "Authorization: Basic ${basicauth}" \
  -H 'Content-Type: application/json' \
  -d @ce-register.json
unset basicauth
git restore ce-register.json

timeout 20 "Wait for the registration to activate %s"

echo "# Approve the registration"

echo '{ "namespace": "system", "state": "PENDING" }' > pending.json

if [[ ${STATE} == "WAITING_FOR_REGISTRATION" ]]; then
  registration=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i pending.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`
  jq -r ".name = \"${registration}\" " approval_req.json | sponge approval_req.json
  vesctl request rpc registration.CustomAPI.RegistrationApprove -i approval_req.json --uri /public/namespaces/system/registration/${registration}/approve --http-method POST
  git restore approval_req.json
fi

rm pending.json


echo "# Wait until the site is ONLINE - maxium 30 minutes"
printstart=$(date +%r)
starttime=$(date -u +%s)
runtime="30 minute"
maxtime=$(date -ud "$runtime" +%s)
STATE=`vesctl configuration get site ${sitename} -n system --outfmt json | jq -r ".spec.site_state"`
while [[ $(date -u +%s) -le $maxtime && ${STATE} != "ONLINE" ]]
do
  endtime=$(date -u +%s)
  elapsedtime=$(( endtime - starttime ))
  outputtime=$(eval "echo $(date -ud "@$elapsedtime" +'%M:%S')")
  timeout 60 "Status: ${STATE} - Started: ${printstart} - Elapsed Time: ${outputtime} - check again %s"
  STATE=`vesctl configuration get site ${sitename} -n system --outfmt json | jq -r ".spec.site_state"`
done
endtime=$(date -u +%s)
elapsedtime=$(( endtime - starttime ))
eval "echo $(date -ud "@$elapsedtime" +'  Elapsed time: %M:%S')"

if [[ "${STATE}" == "ONLINE" ]]; then
  echo "# Download a kubeconfig"
  expiration_timestamp=`date -u --date=tomorrow +%FT%T.%NZ`
  echo "{ \"site\": \"${sitename}\", \"expiration_timestamp\": \"${expiration_timestamp}\" }" > download_kubeconfig.json
  [ -d $HOME/.kube ] || mkdir $HOME/.kube
  curl -sS -v "https://${tenantname}.console.ves.volterra.io/api/web/namespaces/system/sites/${sitename}/global-kubeconfigs" \
    --key $HOME/vesprivate.key \
    --cert $HOME/vescred.cert \
    -H 'Content-Type: application/json' \
    -X 'POST' \
    -d @download_kubeconfig.json \
    -o $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml
fi
rm download_kubeconfig.json

kubectl --kubeconfig $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml get pods -A
