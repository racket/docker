#!/usr/bin/env bash

set -euxfo pipefail;

source "_common.sh";

build_base () {
    docker image build \
           --file "base.Dockerfile" \
           --tag "racket-base" \
           .;
}

build () {
  declare -r dockerfile_name="${1}";
  declare -r installer_url="${2}";
  declare -r version="${3}";
  declare -r image_name="${4}";
  declare -r tag="${DOCKER_REPOSITORY}:${image_name}";
  declare -r secondary_tag="${SECONDARY_DOCKER_REPOSITORY}:${image_name}";

  docker image build \
      --file "${dockerfile_name}.Dockerfile" \
      --tag "${DOCKER_REPOSITORY}:${image_name}" \
      --build-arg "RACKET_INSTALLER_URL=${installer_url}" \
      --build-arg "RACKET_VERSION=${version}" \
      .;

  docker image tag "${tag}" "${secondary_tag}";
};

installer_url () {
  declare -r version="${1}";
  declare -r installer_path="${2}";
  echo "http://mirror.racket-lang.org/installers/${version}/${installer_path}";
};

build_8x () {
  declare -r version="${1}";

  declare -r installer_path="racket-minimal-${version}-x86_64-linux-natipkg.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "${installer}" "${version}" "${version}";

  declare -r bc_installer_path="racket-minimal-${version}-x86_64-linux-bc.sh";
  declare -r bc_installer=$(installer_url "${version}" "${bc_installer_path}") || exit "${?}";
  build "racket" "${bc_installer}" "${version}" "${version}-bc";

  declare -r full_installer_path="racket-${version}-x86_64-linux-natipkg.sh";
  declare -r full_installer=$(installer_url "${version}" "${full_installer_path}") || exit "${?}";
  build "racket" "${full_installer}" "${version}" "${version}-full";

  declare -r full_bc_installer_path="racket-${version}-x86_64-linux-bc.sh";
  declare -r full_bc_installer=$(installer_url "${version}" "${full_bc_installer_path}") || exit "${?}";
  build "racket" "${full_bc_installer}" "${version}" "${version}-bc-full";
};

build_7x () {
  declare -r version="${1}";

  declare -r installer_path="racket-minimal-${version}-x86_64-linux-natipkg.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "${installer}" "${version}" "${version}";

  declare -r cs_installer_path="racket-minimal-${version}-x86_64-linux-natipkg-cs.sh";
  declare -r cs_installer=$(installer_url "${version}" "${cs_installer_path}") || exit "${?}";
  build "racket" "${cs_installer}" "${version}" "${version}-cs";

  declare -r full_installer_path="racket-${version}-x86_64-linux-natipkg.sh";
  declare -r full_installer=$(installer_url "${version}" "${full_installer_path}") || exit "${?}";
  build "racket" "${full_installer}" "${version}" "${version}-full";

  declare -r full_cs_installer_path="racket-${version}-x86_64-linux-natipkg-cs.sh";
  declare -r full_cs_installer=$(installer_url "${version}" "${full_cs_installer_path}") || exit "${?}";
  build "racket" "${full_cs_installer}" "${version}" "${version}-cs-full";
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

declare -r LATEST_RACKET_VERSION="8.3";

build_base;
foreach build_8x "8.0" "8.1" "8.2" "8.3";
foreach build_7x "7.4" "7.5" "7.6" "7.7" "7.8" "7.9";

tag_latest () {
  declare -r repository="${1}";
  docker image tag "${repository}:${LATEST_RACKET_VERSION}" "${repository}:latest";
};

tag_latest "${DOCKER_REPOSITORY}";
tag_latest "${SECONDARY_DOCKER_REPOSITORY}";
