#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

test-image () {
  declare -r image="${1}";
  docker container run "${image}" racket -e "(+ 1 2 3)";

  # Skip this test on Racket 8.{0-6} BC since those versions have issues
  # loading OpenSSL on recent Debian versions.
  if ! [[ "${image}" =~ racket:8.[0123456] ]]; then
      # The "nevermore" package is an empty package that never changes
      # which we created specifically for this test. This lets us test
      # that package installation works and the default package catalogs
      # are properly configured.
      docker container run "${image}" raco pkg install --auto nevermore;
  fi
};

for image in $(find_testable_images "${DOCKER_REPOSITORY}"); do
  test-image "${image}";
done

for image in $(find_testable_images "${SECONDARY_DOCKER_REPOSITORY}"); do
  test-image "${image}";
done
