#!/usr/bin/env bash
if [ "${MOLECULE_INSTANCE_IMAGE}" == "" ]; then
  echo "Variable MOLECULE_INSTANCE_IMAGE has to be set"
  echo "Example values:"
  grep -v ^\# "$(dirname "${0}")/os_versions.txt"
  exit 1
fi

if [ "${HCLOUD_TOKEN}" == "" ]; then
  echo "Variable HCLOUD_TOKEN has to be set"
  exit 1
fi

docker \
  run \
  --rm \
  -it \
  -v "$(pwd):/tmp/$(basename "${PWD}")" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "/tmp/$(basename "${PWD}")" \
  -e MOLECULE_INSTANCE_IMAGE \
  -e MOLECULE_NO_LOG=false \
  -e HCLOUD_TOKEN \
  veselahouba/molecule:v3 \
  molecule "${@}"
