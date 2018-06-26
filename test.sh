#!/usr/bin/env bash

set -euxfo pipefail;

test-image () {
  declare -r version="${1}";
  declare -r image="jackfirth/racket:${version}";
  docker container run -it "${image}" racket -e "(+ 1 2 3)";
  docker container run -it "${image}" raco pkg install --auto rackunit-lib;
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

foreach test-image \
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
