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

find_testable_images () {
    # Version 6.0 is ignored during test runs because its openssl
    # bindings are broken.
    #
    # xref: https://github.com/jackfirth/racket-docker/issues/35
    find_images | grep --invert-match "racket:6.0"
}
