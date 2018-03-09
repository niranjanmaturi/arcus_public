#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

confd -onetime -backend env

function check_mysql_connection() {
  rails r 'begin;ActiveRecord::Base.connection;exit 0;rescue ActiveRecord::NoDatabaseError;exit 0;rescue;exit 1;end'
}

until check_mysql_connection
do
  echo "Waiting for database $DB_HOST"
  sleep 1
done

echo "Connection succeeded"

rake db:create db:migrate db:seed

/etc/init.d/nginx restart
/etc/init.d/nginx status

exec puma -C config/puma.rb
