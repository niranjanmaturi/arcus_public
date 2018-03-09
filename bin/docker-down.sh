#!/usr/bin/env sh
set -o errexit
set -o pipefail
set -o nounset

docker-compose down --remove-orphans