FROM alpine:3.2

RUN apk update && apk add alpine-sdk

ENV RACKET_VERSION 6.2

RUN curl http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-minimal-$RACKET_VERSION-src-builtpkgs.tgz \
  | tar xz

WORKDIR racket-$RACKET_VERSION/src

RUN ./configure && make && make install

WORKDIR /
