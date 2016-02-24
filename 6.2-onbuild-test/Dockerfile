FROM jackfirth/racket:6.2

WORKDIR /src
ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --link --auto
ONBUILD ADD ./src .
ONBUILD RUN raco setup
ONBUILD CMD ["raco", "test", "."]
