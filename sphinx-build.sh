#!/usr/bin/env bash

set -x

if [[ -f "docs/requirements.txt" ]]; then
    REQUIREMENTS='pip install -r docs/requirements.txt -U ;'
fi

COMMAND=(/bin/bash -c "pip install --upgrade pip setuptools wheel ; ${REQUIREMENTS} export READTHEDOCS_PROJECT=f5-xc-iac;  make -C docs clean html")

exec docker run --rm -t \
  -v "$PWD":"$PWD" --workdir "$PWD" \
  ${DOCKER_RUN_ARGS} \
  -e "LOCAL_USER_ID=$(id -u)" \
  sphinxdoc/sphinx:latest "${COMMAND[@]}"
