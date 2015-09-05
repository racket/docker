# racket-docker [![Circle CI](https://circleci.com/gh/jackfirth/racket-docker.svg?style=svg)](https://circleci.com/gh/jackfirth/racket-docker)
Docker images for various Racket versions

#### Normal images

Base: Debian
CMD: `racket`

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

That is, your Dockerfile must be adjacent to a `src` directory containing an `info.rkt` file that lists its dependencies, and a `main.rkt` module that runs your app. Given this setup, the following ONBUILD instructions are triggered:

1. The working directory of the app image is set to `/src`
2. The `src/info.rkt` module is added to the image as `/src/info.rkt`
3. Dependencies are installed with `raco pkg install --link --deps search-auto`
4. The remaining code in `src` is added to the image's `/src` directory
5. The `main.rkt` module is compiled to `/src/main` with `raco exe`
6. The `ENTRYPOINT` of the image is set to `./main`

When working with the `onbuild-test` variants, the same steps occur but with a `raco test .` command between 5 and 6. This allows you to make testing your app part of your build process, which is nice for simple CI builds.
