#!/bin/bash

set -e

cd /srv/bedrock

composer install

wp core install --url=$WP_HOME \
  --title=bedrock \
  --admin_user=dev \
  --admin_email=admin@example.com \
  --admin_password=dev

wp package install aaemnnosttv/wp-cli-login-command \
  || echo 'wp-cli-login-command is already installed'

wp login install --activate --yes --skip-plugins --skip-themes

wp login as 1

/usr/bin/supervisord -c /etc/supervisord.conf > /dev/null
