#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

test-image () {
  declare -r image="${1}";
  docker container run -it "${image}" racket -e "(+ 1 2 3)";
  docker container run -it "${image}" raco pkg install --auto nevermore;
};

for image in $(find_testable_images); do
  test-image "${image}";
done
