ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION
ARG RUN_INSTALLER_COMMAND

RUN wget --output-document=racket-install.sh -q ${RACKET_INSTALLER_URL} && \
    ${RUN_INSTALLER_COMMAND} && \
    rm racket-install.sh

ENV SSL_CERT_FILE="/usr/lib/ssl/cert.pem"
ENV SSL_CERT_DIR="/usr/lib/ssl/certs"

RUN raco setup
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"

CMD ["racket"]
