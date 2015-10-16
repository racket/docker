FROM alpine:3.2

RUN apk update && apk add wget

RUN wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk"
RUN apk add --allow-untrusted glibc-2.21-r2.apk
RUN wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk"
RUN apk add --allow-untrusted glibc-bin-2.21-r2.apk
RUN /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib

RUN apk add gcc curl tar

RUN gcc -print-file-name=libc.so

ENV RACKET_VERSION 6.2

RUN curl http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-minimal-$RACKET_VERSION-src-builtpkgs.tgz \
  | tar xz

WORKDIR racket-$RACKET_VERSION/src

RUN ./configure && make && make install

WORKDIR /
