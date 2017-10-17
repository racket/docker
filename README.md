# racket-docker [![Circle CI](https://circleci.com/gh/jackfirth/racket-docker.svg?style=svg)](https://circleci.com/gh/jackfirth/racket-docker)
Docker images for various Racket versions available on DockerHub as [jackfirth/racket:<version>](https://hub.docker.com/r/jackfirth/racket/)

#### Normal images

Base: Debian jesse

CMD: `racket`

These images use the `minimal-install` of Racket to avoid pulling in things like DrRacket or Scribble. This also means many `raco` commands such as `raco make` will be missing; install the `compiler-lib` package to get most of the standard `raco` commands.

### ONBUILD images

Same as normal images, but with ONBUILD triggers that assume you're developing a Racket application. Your Dockerfile should be in a directory with the following layout:

```
--- <project directory>
 |- Dockerfile
 \--- src
   |- info.rkt
   |- main.rkt
   *  <app code, files or directories>
```

That is, your Dockerfile must be adjacent to a `src` directory containing an `info.rkt` file that lists its dependencies, and a `main.rkt` module that runs your app. The ONBUILD triggers install the `src` directory as a package, and sets `racket main.rkt` as the image's command. The onbuild-test images are similar, but set `raco test .` as the default command. This is useful for CI, as you can add a `Dockerfile.test` file that's `FROM` the onbuild test image, then to run your unit tests just build that image. When testing a multi-language project in CI, it's very useful to only need docker to unit test a project, as otherwise the testing frameworks for each language used would need to be installed at once and configured together properly.

Versions: All 6.x versions and 5.1.2 - 5.3.6 (5.9.x versions have installer issues on debian)
