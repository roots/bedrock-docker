FROM php:8.0.22-fpm-alpine3.16 as php

WORKDIR /srv

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug

RUN apk update && apk add --no-cache -- \
    bash \
    build-base \
    curl \
    git \
    jpegoptim optipng pngquant gifsicle \
    less \
    vim \
    zip

RUN install-php-extensions \
  @composer \
  exif \
  mbstring \
  mysqli \
  pcntl \
  pdo_mysql \
  zip

RUN sed -i \
    -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
    -e "s/pm.max_children = 5/pm.max_children = 64/g" \
    -e "s/pm.start_servers = 2/pm.start_servers = 8/g" \
    -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 8/g" \
    -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 32/g" \
    -e "s/;pm.max_requests = 500/pm.max_requests = 800/g" \
    -e "s/user = www-data/user = nginx/g" \
    -e "s/group = www-data/group = nginx/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    -e "s/;listen.owner = www-data/listen.owner = nginx/g" \
    -e "s/;listen.group = www-data/listen.group = nginx/g" \
    -e "s/listen = 0.0.0.0:9000/listen = \/var\/run\/php-fpm.sock/g" \
    -e "s/^;clear_env = no$/clear_env = no/" \
    /usr/local/etc/php-fpm.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/bin/wp

COPY build/bedrock/start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

RUN addgroup -S web && adduser -S web -G web
RUN chown -R web:web /srv

USER web

RUN git clone https://github.com/roots/bedrock bedrock
WORKDIR /srv/bedrock 

RUN composer install

CMD /srv/start.sh
