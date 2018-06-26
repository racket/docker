ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG RACKET_INSTALLER_URL
ARG RACKET_VERSION

RUN wget --output-document=racket-install.sh -q ${RACKET_INSTALLER_URL} && \
    echo "yes\n1\n" | sh racket-install.sh --create-dir --unix-style --dest /usr/ && \
    rm racket-install.sh

ENV SSL_CERT_FILE="/etc/ssl/ca-certificates.crt"
ENV SSL_CERT_DIR="/etc/ssl/certs"

RUN raco setup

CMD ["racket"]
