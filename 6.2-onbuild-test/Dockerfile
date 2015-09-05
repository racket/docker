FROM racket:6.2

WORKDIR /src
ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --link --deps search-auto
ONBUILD ADD ./src .
ONBUILD RUN raco test .
ONBUILD RUN raco make ./main.rkt
ONBUILD ENTRYPOINT ["./main"]
