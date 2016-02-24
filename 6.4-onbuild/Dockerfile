FROM jackfirth/racket:6.4

WORKDIR /src
ONBUILD RUN raco setup --no-docs
ONBUILD ADD ./src/info.rkt ./info.rkt
ONBUILD RUN raco pkg install --link --auto --binary --no-setup --batch
ONBUILD RUN raco setup --no-docs
ONBUILD ADD ./src .
ONBUILD RUN raco setup --no-docs
ONBUILD CMD ["racket", "main.rkt"]
