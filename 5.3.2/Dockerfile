FROM philcryer/min-wheezy
MAINTAINER Jack Firth <jackhfirth@gmail.com>

RUN apt-get update && \
    apt-get install -y wget sqlite3 && \
    rm -rf /var/lib/apt/lists/*

ENV RACKET_VERSION 5.3.2
ENV RACKET_INSTALLER_URL http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-textual/racket-textual-$RACKET_VERSION-bin-x86_64-linux-debian-squeeze.sh

RUN wget --output-document=racket-install.sh $RACKET_INSTALLER_URL && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

ENV PLT_SETUP_OPTIONS="--no-docs"
RUN raco setup

CMD ["racket"]
