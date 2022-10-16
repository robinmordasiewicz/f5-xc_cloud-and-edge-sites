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

read -s -p "CE node password: " newpassword
if [ ! "${newpassword}" ]; then exit; fi
echo "*********************"

basicauth=`echo -n admin:${newpassword} | base64`
unset newpassword

cenodeaddress=`jq -r ".cenodeaddress" site.json`
cenodeport=`jq -r ".cenodeport" site.json`
echo "# Factory reset the CE password"

curl -sS -k -v "https://${cenodeaddress}:${cenodeport}/api/ves.io.vpm/introspect/write/ves.io.vpm.node/clean" \
  -H "Authorization: Basic ${basicauth}" \
  -H 'Content-Type: application/json' \
  --data-raw '{"reboot":true}'

unset basicauth

echo "# Delete k8s cluster object"
vesctl configuration delete k8s_cluster ${sitename} -n system

echo "# Delete appstack site"
vesctl configuration delete voltstack_site ${sitename} -n system

echo "# Delete site token for registration"
vesctl configuration delete token ${sitename}-token -n system

