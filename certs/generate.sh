#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

# gets the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

country=US
state=Missouri
locality="St Louis"
organization=WWT
organizationalunit=ASY
email=no-reply@asynchrony.com

echo "Remove existing certificates"
find . -name '*.pem' -not -name 'demo-*' -delete

echo "Create CA public & private keys"
commonname=ca
openssl genrsa 2048 > "$DIR/ca-key.pem"
openssl req -new -x509 -nodes -days 3600 -key "$DIR/ca-key.pem" -out "$DIR/ca-cert.pem" -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

create_signed_cert () {
   commonname="$1"

   echo "Creating $commonname signing request"
   openssl req -newkey rsa:2048 -days 3600 -nodes -keyout "$DIR/$commonname-key.pem" -out "$DIR/$commonname-req.pem" -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
   echo "Signing $commonname certificate"
   openssl x509 -req -in "$DIR/$commonname-req.pem" -days 3600 -CA "$DIR/ca-cert.pem" -CAkey "$DIR/ca-key.pem" -set_serial 01 -out "$DIR/$commonname-cert.pem"
   echo "Removing $commonname signing request"
   rm "$DIR/$commonname-req.pem"
   echo "Done creating $commonname public & private keys"
}

create_signed_cert "mysql"
create_signed_cert "localhost"
