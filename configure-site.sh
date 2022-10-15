#!/bin/bash
#

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

is_in_local foo

currentbranch=`git branch --show-current`

if [[ ${currentbranch} == "main" ]]; then
  # in main configure site
  read -p "Site Name: " sitename
  if [ ! "${sitename}" ]; then exit; fi
  if [[ `is_in_local ${sitename}` ]]; then
    git switch ${sitename}
  else
    git checkout -b ${sitename}
  fi
fi

sitename=`jq -r ".sitename" manifests/site.json`

if [[ ${sitename} == "main" ]]; then
  # creating a new site
  read -p "Site Name: " sitename
  if [ ! "${sitename}" ]; then exit; fi
else
  # configuring existing site
  read -p "Site Name: [${sitename}] " sitename
  sitename="${sitename:=${sitename}}"
fi
  
exit

else
  sitename=`jq -r ".sitename" manifests/site.json`
  if [[ $sitename == "main" ]]; then
    # 
    read -p "Site Name: " sitename
  else
    read -p "Site Name: [${sitename}] " sitename
    sitename="${sitename:=${sitename}}"
  fi
fi

if [ ! "${sitename}" ]; then exit; fi


exit

sitename=`jq -r ".sitename" manifests/site.json`

if [[ $sitename == "main" ]]; then
  read -p "Site Name: " sitename
else
  read -p "Site Name: [${sitename}]" sitename
fi

if [ ! "${sitename}" ]; then exit; fi

if [[ ${currentbranch} != $sitename ]]; then
  git switch main
  git checkout -b ${sitename}
fi

exit

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

read -p "Site Address: [801 5th Ave Seattle, WA 98104 United States] " address
address="${address:=801 5th Ave Seattle, WA 98104 United States}"

read -p "Site Latitude: [47.605199] " latitude
latitude="${latitude:=47.605199}"

read -p "Site Longitude: [-122.330996] " longitude
longitude="${longitude:=-122.330996}"

read -p "CE Node IP Addr or DNS name: [10.1.1.5] " cenodeaddress
cenodeaddress="${cenodeaddress:=10.1.1.5}"

read -p "CE Node Port: [65500] " cenodeport
cenodeport="${cenodeport:=65500}"

read -p "CE Node hostname: " nodename
if [ ! "${nodename}" ]; then exit; fi

echo "# Create manifests"
cd manifests/

echo "# Create K8s clsuter"
jq -r ".metadata.name = \"${sitename}\" | .spec.cluster_wide_app_list.cluster_wide_apps[].argo_cd.local_domain.password.blindfold_secret_info.location = \"<removed>\" " k8s_cluster.json | sponge k8s_cluster.json
git add k8s_cluster.json && git commit --quiet -m "creating deployment manifests"

echo "# Create an appstack site"
jq -r ".metadata.name = \"${sitename}\" | .spec.k8s_cluster.name = \"${sitename}\" | .spec.master_nodes[] = \"${nodename}\" | .spec.address = \"${address}\" | .spec.coordinates.latitude = \"${latitude}\" | .spec.coordinates.longitude = \"${longitude}\" " appstack_site.json | sponge appstack_site.json
git add appstack_site.json && git commit --quiet -m "creating deployment manifests"

echo "# Create a site registration approval"
jq -r ".metadata.name = \"${sitename}-token\" " token.json | sponge token.json
git add token.json && git commit --quiet -m "creating deployment manifests"

echo "# Create CE registraion"
jq -r ".cluster_name = \"${sitename}\" | .hostname = \"${nodename}\" | .latitude = \"${latitude}\" | .longitude = \"${longitude}\" " ce-register.json | sponge ce-register.json
git add ce-register.json && git commit --quiet -m "creating deployment manifests"

echo "# Update documentation"


