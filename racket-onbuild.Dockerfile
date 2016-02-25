FROM philcryer/min-wheezy
MAINTAINER Jack Firth <jackhfirth@gmail.com>

RUN apt-get update && \
    apt-get install -y wget sqlite3 ca-certificates openssl && \
    rm -rf /var/lib/apt/lists/*

ARG RACKET_INSTALLER_URL

RUN wget --output-document=racket-install.sh -q $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

ENV PLT_SETUP_OPTIONS="--no-docs"
RUN raco setup

WORKDIR /src
CMD ["racket", "main.rkt"]

ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --link --auto
ONBUILD ADD ./src .
ONBUILD RUN raco setup
