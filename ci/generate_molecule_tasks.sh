#!/usr/bin/env sh
set -e
WDIR=$(dirname "${0}")

cat ./ci/gitlab-ci.yml.base > .gitlab-ci-molecule.yml

grep -v ^\# < "${WDIR}"/os_versions.txt | while IFS= read -r OS_VERSION
do
  echo "Generating job for ${OS_VERSION} ..."
  sed "s#OS_VERSION#${OS_VERSION}#g" ./ci/gitlab-ci.yml.job >> .gitlab-ci-molecule.yml
done
