#!/usr/bin/env bash

# no -x because that leaks password in CI logs
set -eufo pipefail;

docker login \
    --password="${DOCKER_USER_PASSWORD}" \
    --username="${DOCKER_USER_NAME}";
