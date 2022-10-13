#!/bin/bash
#

vesctl configuration apply k8s_cluster -i k8s_cluster.json
vesctl configuration apply voltstack_site -i appstack_site.json
vesctl configuration apply token -i token.json

registration=`vesctl configuration list registration -n system --outfmt json | jq '.items' | jq -r '.[0].name'`
vesctl request rpc registration.CustomAPI.RegistrationApprove -i registration.yaml --uri /public/namespaces/system/registration/${registration}/approve --http-method POST

vesctl request rpc site.UamKubeConfigAPI.CreateGlobalKubeConfig -i global-kubeconfig-download.json --uri /public/namespaces/system/sites/site-name/global-kubeconfigs --http-method POST
