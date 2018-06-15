#!/usr/bin/env bash

set -euxfo pipefail

build_template () {
  declare -r dockerfile="${1}.Dockerfile";
  declare -r tag="jackfirth/racket:${2}";
  declare -r installer_arg="RACKET_INSTALLER_URL=${3}";
  declare -r version_arg="RACKET_VERSION=${4}";
  docker build \
      -f "${dockerfile}" \
      -t "${tag}" \
      --build-arg "${installer_arg}" \
      --build-arg "${version_arg}" \
      .;
}

installer_url () {
  declare -r version="${1}";
  declare -r installer_path="${2}";
  echo "http://mirror.racket-lang.org/installers/${version}/${installer_path}";
}

build_6x () {
  declare -r version="${1}";
  declare -r installer_path="racket-minimal-${version}-x86_64-linux.sh";
  declare -r installer="$(installer_url \"${version}\" \"${installer_path}\")" || exit "${?}";
  declare -r plain_tag="${version}";
  declare -r onbuild_tag="${version}-onbuild";
  declare -r onbuild_test_tag="${version}-onbuild-test";
  build_template "racket" "${plain_tag}" "${installer}" "${version}";
  build_template "racket-onbuild" "${onbuild_tag}" "${installer}" "${version}";
  build_template "racket-onbuild-test" "${onbuild_test_tag}" "${installer}" "${version}";
}

build_6x_debian () {
  declare -r version="${1}";
  declare -r installer_path="racket-minimal-${version}-x86_64-linux-debian-squeeze.sh";
  declare -r installer="$(installer_url \"${version}\" \"${installer_path}\")" || exit "${?}";
  declare -r plain_tag="${version}";
  declare -r onbuild_tag="${version}-onbuild";
  declare -r onbuild_test_tag="${version}-onbuild-test";
  build_template "racket" "${version}" "${installer}" "${version}";
  build_template "racket-onbuild" "${onbuild_tag}" "${installer}" "${version}";
  build_template "racket-onbuild-test" "${onbuild_test_tag}" "${installer}" "${version}";
}

build_5x () {
  declare -r version="${1}";
  declare -r installer_path="racket-textual/racket-textual-${version}-bin-x86_64-linux-debian-squeeze.sh";
  declare -r installer="$(installer_url \"${version}\" \"${installer_path}\")" || exit "${?}";
  build_template "racket-old" "${version}" "${installer}" "${version}";
}

foreach () {
  declare -r command="${1}";
  declare -r args="${@:2}";
  for _arg in "${args}"; do
    "${command}" "${_arg}";
  done
}

foreach build_6x "6.12" "6.11" "6.10.1" "6.10" "6.9" "6.8" "6.7" "6.6" "6.5"
foreach build_6x_debian "6.4" "6.3" "6.2.1" "6.2" "6.1.1" "6.1" "6.0.1" "6.0"
foreach build_5x "5.3.6" "5.3.5" "5.3.4" "5.3.3" "5.3.2" "5.3.1" "5.3" "5.2.1" "5.2" "5.1.3" "5.1.2"
