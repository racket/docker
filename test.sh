#!/usr/bin/env bash

set -euxfo pipefail;

test-image () {
  declare -r version="${1}";
  declare -r image="jackfirth/racket:${version}";
  declare -r eval_test_command="racket -e \"(+ 1 2 3)\"";
  declare -r pkg_test_command="raco pkg install --auto rackunit-lib";
  docker container run -it "${image}" ${eval-test-command};
  docker container run -it "${image}" ${pkg-test-command};
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
    "6.1" \
    "6.0.1" \
    "6.0" \
    "5.3.6" \
    "5.3.5" \
    "5.3.4" \
    "5.3.3" \
    "5.3.2" \
    "5.3.1" \
    "5.3" \
    "5.2.1" \
    "5.2" \
    "5.1.3" \
    "5.1.2";
