#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

test-image () {
  declare -r image="${1}";

  if echo "${image}" | grep "\-full" -q; then
      test_package="deta-lib";  # rackunit-lib is already installed in the -full variant
  else
      test_package="rackunit-lib";
  fi

  docker container run -it "${image}" racket -e "(+ 1 2 3)";
  docker container run -it "${image}" raco pkg install --auto "${test_package}";
};

for image in $(find_images); do
    test-image "${image}";
done
