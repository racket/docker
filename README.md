# racket-docker [![Circle CI](https://circleci.com/gh/jackfirth/racket-docker.svg?style=svg)](https://circleci.com/gh/jackfirth/racket-docker)
Docker images for various Racket versions available on DockerHub as [`racket/racket:<version>`](https://hub.docker.com/r/racket/racket/). For example, to run a Racket 7.7 REPL:

```
$ docker run -it racket/racket:7.7
```

#### Normal images

Base: `buildpack-deps`

CMD: `racket`

These images use the `minimal-install` of Racket to avoid pulling in things like
DrRacket or Scribble. This also means many `raco` commands such as `raco make`
will be missing; install the `compiler-lib` package to get most of the standard
`raco` commands. Alternatively, use the "full" images instead such as
`racket/racket:7.7-full`.

Versions: 6.1 and above. Racket CS images are available for 7.4 and above.

#### "Full" images

Base: `buildpack-deps`

CMD: `racket`

These images, tagged with `-full` at the end, use the full Racket distribution.

#### Racket-on-ChezScheme images

Base: `buildpack-deps`

CMD: `racket`

These images, tagged with `-cs` and `-cs-full` at the end, use the
`minimal-install` and the full install of Racket-on-Chez,
respectively. For example, `racket/racket:7.7-cs-full` is the non-minimal Racket
CS 7.7 variant.

## Local development

To work with the images locally, first run `docker login` to login to DockerHub.
Then run the following scripts:

- `./build.sh` to build the images,
- `./test.sh` to verify that the images work correctly, and
- `./deploy.sh` to push the images to DockerHub.

## Legacy images

These images used to be in the `jackfirth/racket` DockerHub repository. For
backwards compatibility, that repository is still available and images for new
Racket versions are still pushed there. Users are gently encouraged to migrate
to the `racket/racket` repository. The images in both repositories are
identical, and we plan to continue updating the `jackfirth/racket` repository
for the foreseeable future.
