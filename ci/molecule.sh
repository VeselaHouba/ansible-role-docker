#!/usr/bin/env bash
if [ "${MOLECULE_INSTANCE_IMAGE}" == "" ]; then
  echo "Variable MOLECULE_INSTANCE_IMAGE has to be set"
  echo "Example values:"
  cat "$(dirname $0)/os_versions.txt" | grep -v ^\#
  exit 1
fi
docker \
  run \
  --rm \
  -it \
  -v "$(pwd)":/tmp/$(basename "${PWD}") \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /tmp/$(basename "${PWD}") \
  -e MOLECULE_INSTANCE_IMAGE \
  veselahouba/molecule \
  molecule $@
