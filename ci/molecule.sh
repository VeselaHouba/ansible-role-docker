#!/usr/bin/env bash
if [ "${MOLECULE_IMAGE}" == "" ]; then
  echo "Variable MOLECULE_IMAGE not set, using default"
fi
if [ "${HCLOUD_TOKEN}" == "" ]; then
  echo "Variable HCLOUD_TOKEN has to be set"
  exit 1
fi

REPO_NAME="$(basename "${PWD}")"
echo Using repo "${REPO_NAME}"

docker \
  run \
  --rm \
  -it \
  -v "$(pwd):/tmp/$(basename "${PWD}")" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w "/tmp/$(basename "${PWD}")" \
  -e MOLECULE_NO_LOG=false \
  -e MOLECULE_IMAGE \
  -e MOLECULE_DOCKER_COMMAND \
  -e HCLOUD_TOKEN \
  -e REF=manual \
  -e REPO_NAME \
  veselahouba/molecule bash -c "
  shellcheck_wrapper && \
  flake8 && \
  yamllint . && \
  ansible-lint && \
  molecule ${*}"
