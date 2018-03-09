#!/usr/bin/env sh

set -o xtrace
set -o errexit
set -o pipefail
set -o nounset

OUTPUT_DIR=dist
DEFAULT_TAG="$(date "+%Y%m%d.%M%S")"
TAG="${TAG:-$DEFAULT_TAG}"
COMPOSE_VERSION=1.11.2
MARIADB_IMAGE=`grep -E 'image: *mariadb' docker-compose.yml | sed 's/ *image: *//g'`

echo "*** resetting output dir ($OUTPUT_DIR)"
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR/arcus/images

echo "*** fetching commit sha"
git rev-parse --verify HEAD > vendor/.git-sha

echo "*** pull and build docker images"
docker build . --pull -t arcus:$TAG
docker pull $MARIADB_IMAGE
docker pull docker/compose:$COMPOSE_VERSION

echo "*** save docker images to disk"
docker save -o $OUTPUT_DIR/arcus/images/arcus.tar arcus:$TAG
docker save -o $OUTPUT_DIR/arcus/images/mariadb.tar $MARIADB_IMAGE
docker save -o $OUTPUT_DIR/arcus/images/docker-compose.tar docker/compose:$COMPOSE_VERSION

echo "*** exporting version ($TAG)"
echo "$TAG" > $OUTPUT_DIR/arcus/VERSION

echo "*** extract pdf from container"
docker run --rm arcus:$TAG cat public/arcus.pdf > $OUTPUT_DIR/arcus/arcus.pdf

echo "*** copying scripts"
cp -R deploy/* $OUTPUT_DIR/arcus/.

echo "*** copying compose file"
cp docker-compose.yml $OUTPUT_DIR/arcus/compose/.

echo "*** copying certs"
mkdir -p $OUTPUT_DIR/arcus/certs
cp certs/mysql-key.pem $OUTPUT_DIR/arcus/certs/.
cp certs/mysql-cert.pem $OUTPUT_DIR/arcus/certs/.
cp certs/ca-cert.pem $OUTPUT_DIR/arcus/certs/.
cp certs/require_ssl.sql $OUTPUT_DIR/arcus/certs/.

echo "*** zipping the result"
(cd $OUTPUT_DIR && zip -r arcus.zip arcus)
