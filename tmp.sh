#!/bin/bash
#


for keyfield in $(jq -r '.rst_prolog | keys[] as $k | "\($k)"' manifests/site.json); do
  echo ".. |$keyfield| replace:: `jq -r ".rst_prolog.${keyfield}" manifests/site.json`"
done
exit


for animal in $(jq -r '.rst_prolog | @base64' manifests/site.json); do
  _jq() {
    echo ${animal} | base64 --decode | jq -r ${1}
  }
  echo "Hi, I am a $(_jq '.name') and I belong to the $(_jq '.class') class"
done

exit


for row in $(jq - c '.rst_prolog | map(.) | .[]'
   manifests/site.json);
do
   _jq() {
      echo $ {
         row
      } | jq - r "${1}"
   }
echo $(_jq '.desc')
"="
$(_jq '.name')
done
exit

sample=`jq -r ".rst_prolog" manifests/site.json`

echo $sample | while read name ; do
    echo $name
done
exit

for row in $(echo "${sample}" | jq -r '.'); do
    _jq() {
     echo ${row} | jq -r ${1}
    }
   echo $(_jq '.name')
done
