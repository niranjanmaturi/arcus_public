#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset

image=selenium/standalone-chrome
container=`docker ps --filter name=selenium --filter status=running --quiet`

if [[ -z $container ]]; then
    docker rm -f selenium || true
    docker pull $image
    docker run --name selenium -d -p 4444:4444 $image
fi

export SELENIUM_REMOTE_PORT=4444
export SELENIUM_REMOTE_HOST=localhost
export SELENIUM_SERVER_PORT=55555
export SELENIUM_SERVER_HOST=`ipconfig getifaddr en1`

rspec "$@"
