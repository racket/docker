#!/usr/bin/env bash

set -euxfo pipefail;

declare -r LATEST_RACKET_VERSION="7.4";

docker image tag "jackfirth/racket:${LATEST_RACKET_VERSION}" "jackfirth/racket:latest";

push () {
  declare -r version="${1}";
  docker image push "jackfirth/racket:${version}";
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

foreach push \
    "latest" \
    "7.4" \
    "7.3" \
    "7.2" \
    "7.1" \
    "7.0" \
    "6.12" \
    "6.11" \
    "6.10.1" \
    "6.10" \
    "6.9" \
    "6.8" \
    "6.7" \
    "6.6" \
    "6.5" \
    "6.4" \
    "6.3" \
    "6.2.1" \
    "6.2" \
    "6.1.1" \
    "6.1";
