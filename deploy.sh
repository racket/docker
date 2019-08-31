#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

declare -r LATEST_RACKET_VERSION="7.4";

docker image tag "${USERNAME}/racket:${LATEST_RACKET_VERSION}" "${USERNAME}/racket:latest";

push () {
  declare -r image="${1}";
  docker image push "${image}";
};

for image in $(find_images); do
    push "${image}";
done
