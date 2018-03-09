#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

VERSION="1.11.2"
IMAGE="docker/compose:$VERSION"

(cd "$(dirname $0)/compose";
docker run --rm -i \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v $(pwd):$(pwd):ro \
  -w "$(pwd)" \
  --env-file .envfile \
  $IMAGE \
  -p arcus \
  $(cat compose-files) \
  down
)
