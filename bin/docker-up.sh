#!/usr/bin/env sh
set -o errexit
set -o pipefail
set -o nounset

git rev-parse --verify HEAD > vendor/.git-sha

docker-compose pull
docker-compose build --force-rm --pull
docker-compose up --remove-orphans -d

containers=`docker-compose ps -q`
echo "$containers" | while read -r container ; do
  name=`docker inspect --format {{.Name}} ${container}`
  echo "waiting for $name to become healthy"
  while [[ `docker inspect --format {{.State.Health.Status}} ${container}` != 'healthy' ]]; do
    sleep 1
  done
done
