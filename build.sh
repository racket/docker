set -e

build_template () {
  docker build -t jackfirth/racket:$1 -f racket.Dockerfile --build-arg RACKET_INSTALLER_URL=$2 .;
}

build_6x () {
  build_template $1 "http://mirror.racket-lang.org/installers/$1/racket-minimal-$1-x86_64-linux-debian-squeeze.sh";
}

build_5x () {
  build template $1 "http://mirror.racket-lang.org/installers/$1/racket-textual/racket-textual-$1-bin-x86_64-linux-debian-squeeze.sh";
}

build () { docker build -t jackfirth/racket:$1 $1; }
build_6x 6.4
build_6x 6.3
build_6x 6.2.1
build_6x 6.2
build_6x 6.1.1
build_6x 6.1
build_6x 6.0.1
build_6x 6.0
build_5x 5.3.6
build_5x 5.3.5
build_5x 5.3.4
build_5x 5.3.3
build_5x 5.3.2
build_5x 5.3.1
build_5x 5.3
build_5x 5.2.1
build_5x 5.2
build_5x 5.1.3
build_5x 5.1.2
build 6.4-onbuild
build 6.4-onbuild-test
build 6.3-onbuild
build 6.3-onbuild-test
build 6.2.1-onbuild
build 6.2.1-onbuild-test
build 6.2-onbuild
build 6.2-onbuild-test
