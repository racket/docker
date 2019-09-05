#!/usr/bin/env bash

set -euxfo pipefail;

USERNAME="${DOCKER_USERNAME}"

find_images () {
    # This image is filtered out by the grep below so we might as well
    # add it manually rather than come up with some clever regexp.
    echo "${USERNAME}/racket:latest";

    # Grab all of the racket images whose "tag"s start with a digit.
    docker images --format '{{.Repository}}:{{.Tag}}' | \
        grep "^${USERNAME}/racket:[[:digit:]]" | \
        sort;
}
