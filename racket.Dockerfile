FROM base

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION

RUN curl --retry 5 -Ls "${RACKET_INSTALLER_URL}" > racket-install.sh \
    && echo "yes\n1\n" | sh racket-install.sh --create-dir --unix-style --dest /usr/ \
    && rm racket-install.sh

ENV SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
ENV SSL_CERT_DIR="/etc/ssl/certs"

RUN raco setup
RUN raco pkg config --set catalogs \
    "https://download.racket-lang.org/releases/${RACKET_VERSION}/catalog/" \
    "https://pkg-build.racket-lang.org/server/built/catalog/" \
    "https://pkgs.racket-lang.org" \
    "https://planet-compats.racket-lang.org"

CMD ["racket"]
