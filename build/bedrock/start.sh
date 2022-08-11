#!/bin/bash

set -e

wp core install --url=$WP_HOME \
  --title=bedrock \
  --admin_user=dev \
  --admin_email=admin@example.com \
  --admin_password=dev

while true; do sleep 1; done
