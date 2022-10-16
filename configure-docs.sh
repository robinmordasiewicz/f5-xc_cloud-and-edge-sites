#!/bin/bash
#

for keyfield in $(jq -r '.rst_prolog | keys[] as $k | "\($k)"' manifests/site.json); do
  echo ".. |$keyfield| replace:: `jq -r ".rst_prolog.${keyfield}" manifests/site.json`"
done
