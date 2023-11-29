FROM php:8.2-fpm as base
LABEL name=bedrock
LABEL intermediate=true

# Install essential packages
RUN apt-get update \
  && apt-get install -y \
    build-essential \
    curl \
    git \
    gnupg \
    less \
    nano \
    vim \
    unzip \
    zip \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

FROM base as php
LABEL name=bedrock
LABEL intermediate=true

# Install php extensions including xdebug and related packages
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync \
  && install-php-extensions \
    @composer \
    exif \
    gd \ 
    memcached \
    mysqli \
    pcntl \
    pdo_mysql \
    zip \
  && apt-get update \
  && apt-get install -y \
    gifsicle \
    jpegoptim \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libmemcached-dev \
    locales \
    lua-zlib-dev \
    optipng \
    pngquant \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

# Install xdebug
RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

FROM php as bedrock
LABEL name=bedrock

RUN apt-get update \
  && apt-get install -y ca-certificates curl gnupg \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update \
  && apt-get install -y \
    nginx \
    nodejs \
    supervisor \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && npm install -g yarn

# Configure nginx, php-fpm and supervisor
COPY ./build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./build/nginx/sites-enabled /etc/nginx/conf.d
COPY ./build/nginx/sites-enabled /etc/nginx/sites-enabled
COPY ./build/php/8.2/fpm/pool.d /etc/php/8.2/fpm/pool.d
COPY ./build/php/8.2/conf.d/xdebug.ini /etc/php/conf.d/xdebug.ini
COPY ./build/php/8.2/conf.d/error_reporting.ini /etc/php/conf.d/error_reporting.ini
COPY ./build/supervisor/supervisord.conf /etc/supervisord.conf

# WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/bin/_wp;
COPY ./build/bin/wp.sh /srv/wp.sh
RUN chmod +x /srv/wp.sh \
  && mv /srv/wp.sh /usr/bin/wp

# Installation helper
COPY ./build/bin/bedrock-install.sh /srv/bedrock-install.sh
RUN chmod +x /srv/bedrock-install.sh

WORKDIR /srv/bedrock
CMD ["/srv/bedrock-install.sh"]
