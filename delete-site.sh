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

choosestriporexport () {
  if [[ ${p12location} == "0" ]]; then
    echo "Download p12 certificate and retry"
    exit 1
  fi
  # echo "Found ${p12location} - creating ${HOME}/.vesconfig"
  PS3='p12 certificate found: choose to export or strip passphrase: '
  choices=("Export" "Strip")
  select choice in "${choices[@]}"; do
    case $choice in
        "Export")
cat <<EOF > ~/.vesconfig
server-urls: https://${tenantname}.console.ves.volterra.io/api
p12-bundle: ${p12location}
EOF
            if [[ -z "${VES_P12_PASSWORD}" ]]; then
              # VES_P12_PASSWORD does not exist - prompt for passphrase
              read -s -p "Enter cert passphrase: " VES_P12_PASSWORD
              if [ ! "${VES_P12_PASSWORD}" ]; then echo "Error: no cert passphrase: "; exit; fi
              echo "*********************"
              export VES_P12_PASSWORD
              vesctl configuration list contact -n system &>/dev/null
              if [[ $? != "0" ]]; then
                echo "vesctl not working - download new p12 cert"
                exit
              fi
            else
              echo "WARNING: VES_P12_PASSWORD environment variable already set:"
              vesctl configuration list contact -n system &>/dev/null
              if [[ $? != "0" ]]; then
                echo "vesctl not working - try new passphrase:"
                unset VES_P12_PASSWORD
                read -s -p "Enter cert passphrase: " VES_P12_PASSWORD
                if [ ! "${VES_P12_PASSWORD}" ]; then echo "Error: no cert passphrase: "; exit; fi
                echo "*********************"
                export VES_P12_PASSWORD
                vesctl configuration list contact -n system &>/dev/null
                if [[ $? != "0" ]]; then
                  echo "vesctl not working - download new p12 cert"
                  exit
                fi
              fi
            fi
            break
            ;;
        "Strip")
cat <<EOF > ~/.vesconfig
server-urls: https://${tenantname}.console.ves.volterra.io/api
key: $HOME/vesprivate.key
cert: $HOME/vescred.cert
EOF
            if [[ -f ${HOME}/vescred.cert && -f ${HOME}/vesprivate.key ]]; then
              vesctl configuration list contact -n system &>/dev/null
              if [[ $? != "0" ]]; then
                openssl pkcs12 -in ${p12location} -nodes -nokeys -out ${HOME}/vescred.cert
                openssl pkcs12 -in ${p12location} -nodes -nocerts -out ${HOME}/vesprivate.key
                vesctl configuration list contact -n system &>/dev/null
                if [[ $? != "0" ]]; then
                  echo "vesctl not working - download new p12 cert"
                  exit
                fi
              fi
            else
              openssl pkcs12 -in ${p12location} -nodes -nokeys -out ${HOME}/vescred.cert
              openssl pkcs12 -in ${p12location} -nodes -nocerts -out ${HOME}/vesprivate.key
              vesctl configuration list contact -n system &>/dev/null
              if [[ $? != "0" ]]; then
                echo "vesctl not working - download new p12 cert"
                exit
              fi
            fi
            break
            ;;
        *) echo "invalid option";;
    esac
done
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

if [[ -f "${HOME}/${tenantname}.console.ves.volterra.io.api-creds.p12" ]]; then
  p12location="${HOME}/${tenantname}.console.ves.volterra.io.api-creds.p12"
elif [[ -f "${HOME}/Downloads/${tenantname}.console.ves.volterra.io.api-creds.p12" ]]; then
  p12location="${HOME}/Downloads/${tenantname}.console.ves.volterra.io.api-creds.p12"
else
  p12location=0
fi

# echo "check to see if ${HOME}/.vesconfig exists for ${tenantname}"
if [[ -f "${HOME}/.vesconfig" ]] ; then
  # echo "${HOME}/.vesconfig exists"
  if grep -iq "server-urls: https://${tenantname}.console.ves.volterra.io/api" "${HOME}/.vesconfig"; then
    # echo "${HOME}/.vesconfig has the correct tenant url"
    if grep -iq "p12-bundle:" "${HOME}/.vesconfig" ; then
      # echo "${HOME}/.vesconfig has a p12-bundle configured"
      if [[ -z "${VES_P12_PASSWORD}" ]]; then
        # echo " VES_P12_PASSWORD does not exist - prompt for passphrase"
        read -s -p "Enter cert passphrase: " VES_P12_PASSWORD
        if [ ! "${VES_P12_PASSWORD}" ]; then echo "Error: no cert passphrase: "; exit; fi
        echo "*********************"
        export VES_P12_PASSWORD
      fi
      # echo "VES_P12_PASSWORD environment variable already set"
      vesctl configuration list contact -n system &>/dev/null
      if [[ $? != "0" ]]; then
        # echo "vesctl not working - try new passphrase"
        read -s -p "Enter cert passphrase: " VES_P12_PASSWORD
        if [ ! "${VES_P12_PASSWORD}" ]; then echo "Error: no cert passphrase: "; exit; fi
        echo "*********************"
        export VES_P12_PASSWORD
        vesctl configuration list contact -n system &>/dev/null
        if [[ $? != "0" ]]; then
          echo "vesctl not working - download new p12 cert"
          exit
        fi
      fi
      # tenant p12 and passphrase configured
    elif grep -iq "cert:" "${HOME}/.vesconfig" && grep -iq "key:" "${HOME}/.vesconfig"; then
      # echo "${HOME}/.vesconfig has cert/key config"
      certfile=`grep "cert:" "${HOME}/.vesconfig" | cut -f 2 -d " "`
      keyfile=`grep "key:" "${HOME}/.vesconfig" | cut -f 2 -d " "`
      # echo "cert: $certfile"
      # echo "key: $keyfile"
      if [[ -f $certfile && -f $keyfile ]]; then
        # echo "cert/key already exist"
        vesctl configuration list contact -n system &>/dev/null
        if [[ $? != "0" ]]; then
          # echo "vesctl not working - create new $certfile and $keyfile"
          openssl pkcs12 -in ${p12location} -nodes -nokeys -out $certfile
          openssl pkcs12 -in ${p12location} -nodes -nocerts -out $keyfile
          vesctl configuration list contact -n system &>/dev/null
          if [[ $? != "0" ]]; then
            echo "vesctl not working - download new p12 cert"
            echo "try to install cert again"
            exit
          fi
        fi
      else
        # echo "cert and key not found - create new $certfile and $keyfile"
        openssl pkcs12 -in ${p12location} -nodes -nokeys -out $certfile
        openssl pkcs12 -in ${p12location} -nodes -nocerts -out $keyfile
        vesctl configuration list contact -n system &>/dev/null
        if [[ $? != "0" ]]; then
          echo "vesctl not working - download new p12 cert"
          echo "try to install cert again"
          exit
        fi
      fi
      # echo "tenant cert/key with stripped passphrase"
    else
      # right tenant but wrong certs
      echo "Error: cert misconfigured ${HOME}/.vesconfig"
      cat ${HOME}/.vesconfig
      exit 1
    fi
  else
    echo "Error: wrong tenant listed in ${HOME}/.vesconfig"
    cat ${HOME}/.vesconfig
    choosestriporexport
  fi
else
  # no ${HOME}/.vesconfig - check for p12
  choosestriporexport
fi


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

