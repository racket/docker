#!/usr/bin/env bash

set -euxfo pipefail;

case "${1:-x}" in
  8x) declare -r series="8x" ;;
  7x) declare -r series="7x" ;;
  6x) declare -r series="6x" ;;
  snapshot) declare -r series="snapshot" ;;

  *) echo "usage: $0 [6x|7x|8x|snapshot]"
     exit 1
     ;;
esac

source "_common.sh";

build_base () {
  docker image build \
         --file "base.Dockerfile" \
         --tag "base" \
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
  echo "https://download.racket-lang.org/installers/${version}/${installer_path}";
};

build_snapshot () {
  declare -r version="snapshot";

  declare -r installer="https://www.cs.utah.edu/plt/snapshots/current/installers/racket-minimal-current-x86_64-linux-jesse.sh";
  build "racket" "${installer}" "${version}" "${version}";

  declare -r bc_installer="https://www.cs.utah.edu/plt/snapshots/current/installers/racket-minimal-current-x86_64-linux-bc.sh";
  build "racket" "${bc_installer}" "${version}" "${version}-bc";

  declare -r full_installer="https://www.cs.utah.edu/plt/snapshots/current/installers/racket-current-x86_64-linux-jesse.sh";
  build "racket" "${full_installer}" "${version}" "${version}-full";

  declare -r full_bc_installer="https://www.cs.utah.edu/plt/snapshots/current/installers/racket-current-x86_64-linux-bc.sh";
  build "racket" "${full_bc_installer}" "${version}" "${version}-bc-full";
}

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

build_6x_7x_old () {
  declare -r version="${1}";

  declare -r installer_path="racket-minimal-${version}-x86_64-linux-natipkg.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "${installer}" "${version}" "${version}";

  declare -r full_installer_path="racket-${version}-x86_64-linux-natipkg.sh";
  declare -r full_installer=$(installer_url "${version}" "${full_installer_path}") || exit "${?}";
  build "racket" "${full_installer}" "${version}" "${version}-full";
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

declare -r LATEST_RACKET_VERSION="8.4";

tag_latest () {
  declare -r repository="${1}";
  docker image tag "${repository}:${LATEST_RACKET_VERSION}" "${repository}:latest";
};

build_all_8x () {
  foreach build_8x "8.0" "8.1" "8.2" "8.3" "8.4";
  tag_latest "${DOCKER_REPOSITORY}";
  tag_latest "${SECONDARY_DOCKER_REPOSITORY}";
}

build_all_7x () {
  foreach build_6x_7x_old "7.0" "7.1" "7.3";
  foreach build_7x "7.4" "7.5" "7.6" "7.7" "7.8" "7.9";
}

build_all_6x () {
  foreach build_6x_7x_old "6.5" "6.6" "6.7" "6.8" "6.9" "6.10" "6.10.1" "6.11" "6.12";
}

build_base;

case "$series" in
  8x) build_all_8x ;;
  7x) build_all_7x ;;
  6x) build_all_6x ;;
  snapshot) build_snapshot ;;
esac
