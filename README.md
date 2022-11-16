# racket-docker

Docker images for various Racket versions available on DockerHub as [`racket/racket:<version>`](https://hub.docker.com/r/racket/racket/). For example, to run a Racket 8.7 REPL:

```
$ docker run -it racket/racket:8.7
```

#### Normal images

Base: `debian:stable-slim`

CMD: `racket`

These images use the `minimal-install` of Racket to avoid pulling in things like
DrRacket or Scribble. This also means many `raco` commands such as `raco make`
will be missing; install the `compiler-lib` package to get most of the standard
`raco` commands. Alternatively, use the "full" images instead such as
`racket/racket:8.7-full`.

Versions: 6.1 and above. Racket CS images are available for 7.4 and above.

#### "Full" images

Base: `debian:stable-slim`

CMD: `racket`

These images, tagged with `-full` at the end, use the full Racket distribution.

#### Racket on Chez (CS) images

Base: `debian:stable-slim`

CMD: `racket`

As of Racket 8.0, CS is the default variant of Racket so the regular
images (such as `racket/racket:8.0` or `racket/racket:8.0-full`) are
now based on CS.

Racket CS images for versions prior to 8.0 are tagged as `-cs` and
`-cs-full`, respectively.  For example, `racket/racket:7.9-cs-full` is
the full distribution of the CS variant of Racket 7.9.

#### Racket before Chez (BC) images

As of the 8.0 release, Racket BC images are tagged with `-bc` and
`-bc-full`.  For example, `racket/racket:8.0-bc-full` is the full
distribution of the BC variant of Racket 8.0, whereas
`racket/racket:7.9-full` is the full distribution of the BC variant of
Racket 7.9 (before CS was made the default).


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
