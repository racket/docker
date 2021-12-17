#!/usr/bin/env bash

set -euxfo pipefail

source _common.sh

push() {
  declare -r image="${1}"
  docker image push "${image}"
}

for image in $(find_images "${DOCKER_REPOSITORY}"); do
  push "${image}"
done

for image in $(find_images "${SECONDARY_DOCKER_REPOSITORY}"); do
  push "${image}"
done
