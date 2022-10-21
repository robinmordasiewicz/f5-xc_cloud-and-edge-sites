#!/bin/bash
#

argocdpassword=Volterra123
vesctl request secrets get-public-key > public-key.key
vesctl request secrets get-policy-document --namespace shared --name ves-io-allow-volterra > secret-policy-ves-io-allow-volterra.crt
echo -n ${argocdpassword} > password.key
unset argocdpassword
vesctl request secrets encrypt --policy-document secret-policy-ves-io-allow-volterra.crt --public-key public-key.key password.key
