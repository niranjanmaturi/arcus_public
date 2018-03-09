#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

original_dir=$(pwd)

export INSTALL_DIR=$(echo "$(cd "$(dirname "$0" )"; pwd)")
export ARCUS_TAG="$(cat $INSTALL_DIR/VERSION)"
export PRODUCTION_PASSWORD="${PRODUCTION_PASSWORD:-dc6f0f642ad50e7460076198502f8bb7a07af4572e26716392a9a2a0d8a3560c2e77d1f46b71fab33d1e9e8a51a19afb8fe8cc521d2b5f94b3a9f2464a9d0d9c}"
export ARCUS_CERT_DIR="${ARCUS_CERT_DIR:-/opt/arcus/certs}"
export ARCUS_CERT_KEY="${ARCUS_CERT_KEY:-ssl.key}"
export ARCUS_CERT_FILE="${ARCUS_CERT_FILE:-ssl.cert}"
export MYSQL_DATA_DIR="${MYSQL_DATA_DIR:-/opt/arcus/data}"
export ARCUS_HTTP_PORT="${ARCUS_HTTP_PORT:-80}"
export ARCUS_HTTPS_PORT="${ARCUS_HTTPS_PORT:-443}"

echo "*** loading docker images"
ls -1 $INSTALL_DIR/images/*.tar | xargs -n 1 docker load -i

echo "*** preparing compose files"
cd $INSTALL_DIR/compose

echo -n "-f docker-compose.yml " > compose-files
echo -n "-f docker-compose-prod.yml " >> compose-files
if [ -f "$ARCUS_CERT_DIR/$ARCUS_CERT_KEY" ] && [ -f "$ARCUS_CERT_DIR/$ARCUS_CERT_FILE" ]
then
  echo -n "-f docker-compose-prod-ssl.yml " >> compose-files
fi

echo "" > .envfile
echo "PRODUCTION_PASSWORD=$PRODUCTION_PASSWORD" >> .envfile
echo "DOCKER_HOST=${DOCKER_HOST:-}" >> .envfile
echo "ARCUS_TAG=$ARCUS_TAG" >> .envfile
echo "ARCUS_CERT_DIR=$ARCUS_CERT_DIR" >> .envfile
echo "ARCUS_CERT_KEY=$ARCUS_CERT_KEY" >> .envfile
echo "ARCUS_CERT_FILE=$ARCUS_CERT_FILE" >> .envfile
echo "INSTALL_DIR=$INSTALL_DIR" >> .envfile
echo "MYSQL_DATA_DIR=$MYSQL_DATA_DIR" >> .envfile
echo "ARCUS_HTTP_PORT=$ARCUS_HTTP_PORT" >> .envfile
echo "ARCUS_HTTPS_PORT=$ARCUS_HTTPS_PORT" >> .envfile

echo "*** running docker-compose"
VERSION="1.11.2"
IMAGE="docker/compose:$VERSION"

docker run --rm -i \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v $(pwd):$(pwd):ro \
  -w "$(pwd)" \
  --env-file .envfile \
  $IMAGE \
  $(cat compose-files) \
  -p arcus \
  up --remove-orphans -d

cd $original_dir

echo ""
echo "*** Setup complete"
echo ""
echo "The default administrator username is: admin@example.com"
echo "Set the password using the following command:"
echo ""
echo "docker exec -it arcus_web_1 rake reset_admin admin@example.com"
