#!/bin/bash

set -e

cd /srv/bedrock

composer install

wp core install --url=$WP_HOME \
  --title=bedrock \
  --admin_user=dev \
  --admin_email=admin@example.com \
  --admin_password=dev

/usr/bin/supervisord -c /etc/supervisord.conf
