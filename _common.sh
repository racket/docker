#!/usr/bin/env bash

set -euxfo pipefail;

find_images () {
    docker images --format '{{.Repository}}:{{.Tag}}' | grep "^jackfirth/racket:[[:digit:]]" | sort
}
