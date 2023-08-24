#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

push () {
  declare -r image="${1}";

  # Avoid pushing images with broken SSL up to Docker Hub. Working
  # versions of these images have already been pushed. See the note in
  # test.sh for details.
  if ! [[ "${image}" =~ racket:8.[0123456]-bc ]]; then
      docker image push "${image}";
  fi
};

for image in $(find_images "${DOCKER_REPOSITORY}"); do
  push "${image}";
done

for image in $(find_images "${SECONDARY_DOCKER_REPOSITORY}"); do
  push "${image}";
done
