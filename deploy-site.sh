#!/bin/bash
#

echo "# Set up tenant name and check for credentials"
read -p "Tenant Name: [f5-amer-ent] " tenantname
tenantname="${tenantname:=f5-amer-ent}"

echo "checking for p12 cert"
openssl pkcs12 -in ~/${tenantname}.console.ves.volterra.io.api-creds.p12 -nodes -nokeys -out ~/vescred.cert
openssl pkcs12 -in ~/${tenantname}.console.ves.volterra.io.api-creds.p12 -nodes -nocerts -out ~/vesprivate.key

cat <<EOF > ~/.vesconfig
server-urls: https://${tenantname}.console.ves.volterra.io/api
key: $HOME/vesprivate.key
cert: $HOME/vescred.cert
EOF

read -p "Site Name: " sitename
if [ ! "${sitename}" ]; then exit; fi

git checkout -b ${sitename}


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


read -s -p "CE node new password: " newpassword
if [ ! "${newpassword}" ]; then exit; fi
echo "*********************"

echo "# Change the CE password"
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
cd manifests/

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
registration=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i pending.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`
jq -r ".name = \"${registration}\" " approval_req.json | sponge approval_req.json
vesctl request rpc registration.CustomAPI.RegistrationApprove -i approval_req.json --uri /public/namespaces/system/registration/${registration}/approve --http-method POST
git restore approval_req.json

timeout 30 "Wait for the site to appear before provisioning %s"

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
  jq -r ".site = \"${sitename}\" | .expiration_timestamp = \"${expiration_timestamp}\" " download_kubeconfig.json | sponge download_kubeconfig.json
  [ -d $HOME/.kube ] || mkdir $HOME/.kube
  curl -sS -v "https://${tenantname}.console.ves.volterra.io/api/web/namespaces/system/sites/${sitename}/global-kubeconfigs" \
    --key $HOME/vesprivate.key \
    --cert $HOME/vescred.cert \
    -H 'Content-Type: application/json' \
    -X 'POST' \
    -d @download_kubeconfig.json \
    -o $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml
fi
git restore download_kubeconfig.json

kubectl --kubeconfig $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml get pods -A
