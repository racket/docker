#!/usr/bin/env bash

set -euxfo pipefail

build_template () {
  docker build -f ${1}.Dockerfile -t jackfirth/racket:${2} --build-arg RACKET_INSTALLER_URL=${3} --build-arg RACKET_VERSION=${4} .;
}

build_6x () {
  build_template racket ${1} "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux.sh" ${1};
}

build_6x_debian () {
  build_template racket ${1} "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux-debian-squeeze.sh" ${1};
}

build_5x () {
  build_template racket-old ${1} "http://mirror.racket-lang.org/installers/${1}/racket-textual/racket-textual-${1}-bin-x86_64-linux-debian-squeeze.sh" ${1};
}

build_onbuild_6x () {
  build_template racket-onbuild ${1}-onbuild "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux.sh" ${1};
}

build_onbuild_test_6x () {
  build_template racket-onbuild-test ${1}-onbuild-test "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux.sh" ${1};
}

build_onbuild_6x_debian () {
  build_template racket-onbuild ${1}-onbuild "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux-debian-squeeze.sh" ${1};
}

build_onbuild_test_6x_debian () {
  build_template racket-onbuild-test ${1}-onbuild-test "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux-debian-squeeze.sh" ${1};
}

build_onbuild_latest () {
  build_template racket-onbuild ${1}-onbuild "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux.sh" ${1};
}

build_onbuild_test_latest () {
  build_template racket-onbuild-test ${1}-onbuild-test "http://mirror.racket-lang.org/installers/${1}/racket-minimal-${1}-x86_64-linux.sh" ${1};
}

foreach () {
  local command=${1};
  shift;
  for arg in "$@"; do
    ${command} $arg;
  done
}

foreach build_6x 6.12 6.11 6.10.1 6.10 6.9 6.8 6.7 6.6 6.5
foreach build_6x_debian 6.4 6.3 6.2.1 6.2 6.1.1 6.1 6.0.1 6.0
foreach build_5x 5.3.6 5.3.5 5.3.4 5.3.3 5.3.2 5.3.1 5.3 5.2.1 5.2 5.1.3 5.1.2
build_onbuild_latest 6.12
build_onbuild_test_latest 6.12
foreach build_onbuild_6x 6.11 6.10.1 6.10 6.9 6.8 6.7 6.6 6.5
foreach build_onbuild_test_6x 6.11 6.10.1 6.10 6.9 6.8 6.7 6.6 6.5
foreach build_onbuild_6x_debian 6.4 6.3 6.2.1 6.2
foreach build_onbuild_test_6x_debian 6.4 6.3 6.2.1 6.2
