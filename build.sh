#!/usr/bin/env bash

set -euxfo pipefail;

build () {
  declare -r dockerfile_name="${1}";
  declare -r base_image="${2}";
  declare -r installer_url="${3}";
  declare -r version="${4}";
  docker image build \
      --file "${dockerfile_name}.Dockerfile" \
      --tag "jackfirth/racket:${version}" \
      --build-arg "BASE_IMAGE=${base_image}" \
      --build-arg "RACKET_INSTALLER_URL=${installer_url}" \
      --build-arg "RACKET_VERSION=${version}" \
      .;
};

installer_url () {
  declare -r version="${1}";
  declare -r installer_path="${2}";
  echo "http://mirror.racket-lang.org/installers/${version}/${installer_path}";
};

build_6x_stable_natipkg () {
  declare -r version="${1}";
  declare -r installer_path="racket-minimal-${version}-x86_64-linux-natipkg.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "buildpack-deps:stable" "${installer}" "${version}";
};

build_6x_squeeze_natipkg () {
  declare -r version="${1}";
  declare -r installer_path="racket-minimal-${version}-x86_64-linux-natipkg-debian-squeeze.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "buildpack-deps:squeeze" "${installer}" "${version}";
};

build_6x_squeeze_ospkg () {
  declare -r version="${1}";
  declare -r installer_path="racket-minimal-${version}-x86_64-linux-debian-squeeze.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket" "buildpack-deps:squeeze" "${installer}" "${version}";
};

build_5x_squeeze_ospkg () {
  declare -r version="${1}";
  declare -r installer_path="racket-textual/racket-textual-${version}-bin-x86_64-linux-debian-squeeze.sh";
  declare -r installer=$(installer_url "${version}" "${installer_path}") || exit "${?}";
  build "racket-old" "buildpack-deps:squeeze" "${installer}" "${version}";
};

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in ${args}; do
    "${command}" "${_arg}";
  done;
};

foreach build_6x_stable_natipkg "6.12" "6.11" "6.10.1" "6.10" "6.9" "6.8" "6.7" "6.6" "6.5";
foreach build_6x_squeeze_natipkg "6.4" "6.3" "6.2.1" "6.2" "6.1.1";
foreach build_6x_squeeze_ospkg "6.1" "6.0.1" "6.0";
foreach build_5x_squeeze_ospkg "5.3.6" "5.3.5" "5.3.4" "5.3.3" "5.3.2" "5.3.1" "5.3" "5.2.1" "5.2" "5.1.3" "5.1.2";
