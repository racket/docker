#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

push () {
  declare -r image="${1}";
  docker image push "${image}";
};

for image in $(find_images); do
  push "${image}";
done
