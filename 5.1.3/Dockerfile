FROM debian
MAINTAINER Jack Firth <jackhfirth@gmail.com>

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

ENV RACKET_VERSION 5.1.3
ENV RACKET_INSTALLER_URL http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket/racket-$RACKET_VERSION-bin-x86_64-linux-debian-squeeze.sh

RUN wget --output-document=racket-install.sh $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

CMD ["racket"]
