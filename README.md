# racket-docker [![Circle CI](https://circleci.com/gh/jackfirth/racket-docker.svg?style=svg)](https://circleci.com/gh/jackfirth/racket-docker)
Docker images for various Racket versions available on DockerHub as [`jackfirth/racket:<version>`](https://hub.docker.com/r/jackfirth/racket/)

#### Normal images

Base: `buildpack-deps`

CMD: `racket`

These images use the `minimal-install` of Racket to avoid pulling in things like
DrRacket or Scribble. This also means many `raco` commands such as `raco make`
will be missing; install the `compiler-lib` package to get most of the standard
`raco` commands.

Versions: All 6.x versions and 5.1.2 - 5.3.6 (5.9.x versions have installer
issues on debian)
