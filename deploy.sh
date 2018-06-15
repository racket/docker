#!/usr/bin/env bash

set -euxfo pipefail;

declare -r LATEST_RACKET_VERSION="6.12";

docker login \
    --email="${DOCKER_USER_EMAIL}" \
    --password="${DOCKER_USER_PASSWORD}" \
    --username="${DOCKER_USER_NAME}";

docker tag "jackfirth/racket:${LATEST_RACKET_VERSION}" "jackfirth/racket:latest";

push () {
  declare -r version="${1}";
  docker push "jackfirth/racket:${version}";
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

foreach push \
    latest \
    6.12 \
    6.12-onbuild \
    6.12-onbuild-test \
    6.11 \
    6.11-onbuild \
    6.11-onbuild-test \
    6.10.1 \
    6.10.1-onbuild \
    6.10.1-onbuild-test \
    6.10 \
    6.10-onbuild \
    6.10-onbuild-test \
    6.9 \
    6.9-onbuild \
    6.9-onbuild-test \
    6.8 \
    6.8-onbuild \
    6.8-onbuild-test \
    6.7 \
    6.7-onbuild \
    6.7-onbuild-test \
    6.6 \
    6.6-onbuild \
    6.6-onbuild-test \
    6.5 \
    6.5-onbuild \
    6.5-onbuild-test \
    6.4 \
    6.4-onbuild \
    6.4-onbuild-test \
    6.3 \
    6.3-onbuild \
    6.3-onbuild-test \
    6.2.1 \
    6.2.1-onbuild \
    6.2.1-onbuild-test \
    6.2 \
    6.2-onbuild \
    6.2-onbuild-test \
    6.1.1 \
    6.1.1-onbuild \
    6.1.1-onbuild-test \
    6.1 \
    6.1-onbuild \
    6.1-onbuild-test \
    6.0.1 \
    6.0.1-onbuild \
    6.0.1-onbuild-test \
    6.0 \
    6.0-onbuild \
    6.0-onbuild-test \
    5.3.6 \
    5.3.5 \
    5.3.4 \
    5.3.3 \
    5.3.2 \
    5.3.1 \
    5.3 \
    5.2.1 \
    5.2 \
    5.1.3 \
    5.1.2;
