FROM philcryer/min-wheezy
MAINTAINER Jack Firth <jackhfirth@gmail.com>

RUN apt-get update && \
    apt-get install -y wget sqlite3 ca-certificates openssl && \
    rm -rf /var/lib/apt/lists/*

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION

RUN wget --output-document=racket-install.sh -q $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

RUN raco setup
RUN raco pkg config --set catalogs "https://download.racket-lang.org/releases/$RACKET_VERSION/catalog/" "https://pkg-build.racket-lang.org/server/built/catalog/" "https://pkgs.racket-lang.org" "https://planet-compats.racket-lang.org"

WORKDIR /src
CMD ["racket", "main.rkt"]

ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --auto --no-setup
ONBUILD RUN raco setup --no-docs
ONBUILD ADD ./src .
ONBUILD RUN raco setup --no-docs
