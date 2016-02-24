set -e

docker login --email="${DOCKER_USER_EMAIL}" --password="${DOCKER_USER_PASSWORD}" --username="${DOCKER_USER_NAME}"
push () { docker push jackfirth/racket:$1; }
push 6.4
push 6.3
push 6.2.1
push 6.2
push 6.1.1
push 6.1
push 6.0.1
push 6.0
push 5.3.6
push 5.3.5
push 5.3.4
push 5.3.3
push 5.3.2
push 5.3.1
push 5.3
push 5.2.1
push 5.2
push 5.1.3
push 5.1.2
push 6.4-onbuild
push 6.4-onbuild-test
push 6.3-onbuild
push 6.3-onbuild-test
push 6.2.1-onbuild
push 6.2.1-onbuild-test
push 6.2-onbuild
push 6.2-onbuild-test
