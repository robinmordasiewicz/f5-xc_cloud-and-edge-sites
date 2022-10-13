#!/bin/bash
#

git checkout -b deployment

echo "# running in manifest folder"
cd manifests/

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

read -p "Tenant Name: [f5-xc-lab-app] " tenantname
tenantname="${tenantname:=f5-xc-lab-app}"

read -p "Site Address: [801 5th Ave Seattle, WA 98104 United States] " address
address="${address:=801 5th Ave Seattle, WA 98104 United States}"

read -p "Site Latitude: [47.605199] " latitude
latitude="${latitude:=47.605199}"

read -p "Site Longitude: [-122.330996] " longitude
longitude="${longitude:=-122.330996}"

read -p "Site Name: " sitename
if [ ! "${sitename}" ]; then exit; fi

read -p "Node IP Addr: [10.1.1.5] " ipaddr
ipaddr="${ipaddr:=10.1.1.5}"

read -p "Nodename: " nodename
if [ ! "${nodename}" ]; then exit; fi

read -p "New node password: " newpassword
if [ ! "${newpassword}" ]; then exit; fi

read -p "Namespace: " namespace
if [ ! "${namespace}" ]; then exit; fi

echo "# Create a k8s cluster object"
jq -r ".metadata.name = \"${sitename}\" " k8s_cluster.json | sponge k8s_cluster.json
git add k8s_cluster.json && git commit --quiet -m "creating deployment manifests"
vesctl configuration apply k8s_cluster -i k8s_cluster.json

echo "# Create an appstack site"
jq -r ".metadata.name = \"${sitename}\" | .spec.k8s_cluster.name = \"${sitename}\" | .spec.master_nodes[] = \"${nodename}\" | .spec.address = \"${address}\" | .spec.coordinates.latitude = \"${latitude}\" | .spec.coordinates.longitude = \"${longitude}\" " appstack_site.json | sponge appstack_site.json
git add appstack_site.json && git commit --quiet -m "creating deployment manifests"
vesctl configuration apply voltstack_site -i appstack_site.json

echo "# Create a site token for registration"
jq -r ".metadata.name = \"${sitename}-token\" " token.json | sponge token.json
git add token.json && git commit --quiet -m "creating deployment manifests"
vesctl configuration apply token -i token.json
timeout 15 "# Wait for token creation %s"
token=`vesctl configuration get token ${sitename}-token --outfmt json -n system | jq -r ".system_metadata.uid"`

echo "# Change the CE password"
curl -sS -k "https://${ipaddr}:65500/api/ves.io.vpm/introspect/write/ves.io.vpm.node/change-password" \
  -H 'Accept: application/json, text/plain, */*' \
  -u "admin:Volterra123" \
  -H 'Content-Type: application/json' \
  --data-raw "{\"current_password\":\"Volterra123\",\"new_password\":\"${newpassword}\",\"username\":\"admin\"}"

timeout 30 "# Wait for the CE to reconfigure %s"

echo "# Register the CE"
jq -r ".token = \"${token}\" | .cluster_name = \"${sitename}\" | .hostname = \"${nodename}\" | .latitude = \"${latitude}\" | .longitude = \"${longitude}\" " ce-register.json | sponge ce-register.json
git add ce-register.json && git commit --quiet -m "creating deployment manifests"
curl -sS -k "https://${ipaddr}:65500/api/ves.io.vpm/introspect/write/ves.io.vpm.config/update" \
  -u "admin:${newpassword}" \
  -H 'Content-Type: application/json' \
  -d @ce-register.json

timeout 20 "Wait for the registration to activate %s"

echo "# Approve the registration"
registration=`vesctl configuration list registration -n system --outfmt json | jq '.items' | jq -r '.[0].name'`
jq -r ".name = \"${registration}\" | .passport.cluster_name = \"${sitename}\" | .passport.latitude = \"${latitude}\" | .passport.longitude = \"${longitude}\" " approval_req.json | sponge approval_req.json
git add approval_req.json && git commit --quiet -m "creating deployment manifests"
vesctl request rpc registration.CustomAPI.RegistrationApprove -i approval_req.json --uri /public/namespaces/system/registration/${registration}/approve --http-method POST

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
  git add download_kubeconfig.json && git commit --quiet -m "creating deployment manifests"
  [ -d $HOME/.kube ] || mkdir $HOME/.kube
  curl -sS "https://${tenantname}.console.ves.volterra.io/api/web/namespaces/system/sites/${sitename}/global-kubeconfigs" \
    --key $HOME/vesprivate.key \
    --cert $HOME/vescred.cert \
    -H 'Content-Type: application/json' \
    -X 'POST' \
    -d @download_kubeconfig.json \
    -o $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml
fi

kubectl --kubeconfig $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml get pods -A
