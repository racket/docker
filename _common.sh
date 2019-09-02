#!/usr/bin/env bash

set -euxfo pipefail;

USERNAME="${DOCKER_USERNAME}"

find_images () {
    docker images --format '{{.Repository}}:{{.Tag}}' | \
        grep "^${USERNAME}/racket:[[:digit:]]" | \
        sort;
}
