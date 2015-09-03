FROM debian
MAINTAINER Jack Firth <jackhfirth@gmail.com>

RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

ENV RACKET_VERSION 5.3.2

RUN wget --output-document=racket-install.sh \
         http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket/racket-$RACKET_VERSION-x86_64-linux-debian-squeeze.sh && \
    echo "yes\n1\n" | /bin/bash racket-install.sh && \
    rm racket-install.sh

CMD ["racket"]
