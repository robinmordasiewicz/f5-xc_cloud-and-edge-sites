#!/bin/bash
#

if [[ -f "${HOME}/${tenantname}.console.ves.volterra.io.api-creds.p12" ]]; then
  p12location="${HOME}/${tenantname}.console.ves.volterra.io.api-creds.p12"
elif [[ -f "${HOME}/Downloads/${tenantname}.console.ves.volterra.io.api-creds.p12" ]]; then
  p12location="${HOME}/Downloads/${tenantname}.console.ves.volterra.io.api-creds.p12"
else
  p12location=0
fi

VES_P12_PASSWORD

export sitename=k8s-cluster-site
export tenantname=bny
  echo "# Download a kubeconfig"
  expiration_timestamp=`date -u --date=tomorrow +%FT%T.%NZ`
  echo "{ \"site\": \"${sitename}\", \"expiration_timestamp\": \"${expiration_timestamp}\" }" > download_kubeconfig.json
  [ -d $HOME/.kube ] || mkdir $HOME/.kube
  if [[ -f ${HOME}/vescred.cert && -f ${HOME}/vesprivate.key ]]; then
    curl -sS -v "https://${tenantname}.console.ves.volterra.io/api/web/namespaces/system/sites/${sitename}/global-kubeconfigs" \
      --key $HOME/vesprivate.key \
      --cert $HOME/vescred.cert \
      -H 'Content-Type: application/json' \
      -X 'POST' \
      -d @download_kubeconfig.json \
      -o $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml
  elif [[ ${p12location} != "0" ]]; then
    curl -sS -v "https://${tenantname}.console.ves.volterra.io/api/web/namespaces/system/sites/${sitename}/global-kubeconfigs" \
      --cert-type P12 --cert ${p12location}:${VES_P12_PASSWORD} \
      -H 'Content-Type: application/json' \
      -X 'POST' \
      -d @download_kubeconfig.json \
      -o $HOME/.kube/ves_system_${sitename}_kubeconfig_global.yaml
  fi

rm download_kubeconfig.json
