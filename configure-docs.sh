#!/bin/bash
#

if [[ -e docs/rst_prolog.inc ]]; then rm docs/rst_prolog.inc; fi
for keyfield in $(jq -r '.rst_prolog | keys[] as $k | "\($k)"' manifests/site.json); do
  echo ".. |$keyfield| replace:: `jq -r ".rst_prolog.${keyfield}" manifests/site.json`" >> docs/rst_prolog.inc
done
