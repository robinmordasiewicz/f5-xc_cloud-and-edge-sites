#!/bin/bash

token='5c7dab03-9ee3-4813-b588-c7bee8b7e6b7'

echo '{ "namespace": "system", "state": "PENDING" }' > pending.json
pending=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i pending.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`

if [ -z "$pending" ]; then echo "NULL"; else echo "Not NULL"; fi

echo '{ "namespace": "system", "state": "ADMITTED" }' > admitted.json
admitted=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i admitted.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`

echo '{ "namespace": "system", "state": "ONLINE" }' > online.json
online=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i online.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`

echo "pending = $pending"
echo "admitted = $admitted"
echo "online = $online"
exit


registration=`vesctl request rpc registration.CustomAPI.ListRegistrationsByState -i pending.json --uri /public/namespaces/system/listregistrationsbystate --http-method POST | yq -o=json | jq -r ".items[] | select(.getSpec.token == \"${token}\") | .name"`
jq -r ".name = \"${registration}\" " approval_req.json | sponge approval_req.json
vesctl request rpc registration.CustomAPI.RegistrationApprove -i approval_req.json --uri /public/namespaces/system/registration/${registration}/approve --http-method POST
rm pending.json
git restore approval_req.json
