#!/usr/bin/env bash

set -euxfo pipefail;

DOCKER_REPOSITORY="racket/racket";

# We used to push images to the jackfirth/racket DockerHub repo instead
# of racket/racket. For backwards compatibility, we still push the images
# to that repo in addition to the primary racket/racket repo.
SECONDARY_DOCKER_REPOSITORY="jackfirth/racket";

find_images () {
    declare -r repository="${1}";

    # This image is filtered out by the grep below so we might as well
    # add it manually rather than come up with some clever regexp.
    echo "${repository}:latest";

    # Grab all of the racket images whose "tag"s start with a digit.
    docker images --format '{{.Repository}}:{{.Tag}}' | \
        grep "^${repository}:[[:digit:]]" | \
        sort;
}

find_testable_images () {
    declare -r repository="${1}";

    # Version 6.0 is ignored during test runs because its openssl
    # bindings are broken.
    #
    # xref: https://github.com/jackfirth/racket-docker/issues/35
    find_images "${repository}" | grep --invert-match "${repository}:6.0"
}
