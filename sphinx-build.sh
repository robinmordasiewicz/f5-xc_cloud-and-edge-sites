#!/usr/bin/env bash

set -x

COMMAND=(/bin/bash -c "pip install --upgrade pip setuptools wheel ; pip install -r docs/requirements.txt -U ; make -C docs clean html")


exec docker run --rm -t \
  -v "$PWD":"$PWD" --workdir "$PWD" \
  ${DOCKER_RUN_ARGS} \
  -e "LOCAL_USER_ID=$(id -u)" \
  sphinxdoc/sphinx:latest "${COMMAND[@]}"