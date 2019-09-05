# racket-docker [![Circle CI](https://circleci.com/gh/jackfirth/racket-docker.svg?style=svg)](https://circleci.com/gh/jackfirth/racket-docker)
Docker images for various Racket versions available on DockerHub as [`jackfirth/racket:<version>`](https://hub.docker.com/r/jackfirth/racket/)

#### Normal images

Base: `buildpack-deps`

CMD: `racket`

These images use the `minimal-install` of Racket to avoid pulling in things like
DrRacket or Scribble. This also means many `raco` commands such as `raco make`
will be missing; install the `compiler-lib` package to get most of the standard
`raco` commands.

Versions: 6.1 and above

#### "Full" images

Base: `buildpack-deps`

CMD: `racket`

These images, tagged with `-full` at the end, use the full Racket
distribution.

## Building the images

To build the images locally, run

    $ env DOCKER_USERNAME=you ./build.sh

from the command line, replacing `you` with whatever your Docker Hub
username is.  After building the images, you can test them all with

    $ env DOCKER_USERNAME=you ./test.sh

and you can deploy them to Docker Hub with

    $ env DOCKER_USERNAME=you ./deploy.sh
