FROM php:8.0-fpm

WORKDIR /srv

# Install php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync \
 && install-php-extensions \
  @composer \
  exif \
  gd \ 
  mbstring \
  memcached \
  mysqli \
  pcntl \
  pdo_mysql \
  zip

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    less \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    supervisor \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip \
    lua-zlib-dev \
    libmemcached-dev \
    nginx &&\
  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false &&\
  rm -rf /var/lib/apt/lists/* &&\
  apt-get clean

# Copy configs
COPY ./build/supervisor/supervisord.conf /etc/supervisord.conf
COPY ./build/php/8.0/fpm/pool.d /etc/php/8.0/fpm/pool.d
COPY ./build/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./build/nginx/sites-enabled /etc/nginx/conf.d
COPY ./build/nginx/sites-enabled /etc/nginx/sites-enabled

# WordPress CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
  chmod +x wp-cli.phar &&\
  mv wp-cli.phar /usr/bin/_wp;

# Passthrough WordPress CLI wrapper (to avoid permissions complexities)
COPY ./build/bin/wp.sh /srv/wp.sh
RUN chmod +x /srv/wp.sh
RUN cp /srv/wp.sh /usr/bin/wp

# Installer / entrypoint
COPY ./build/bin/bedrock-install.sh /srv/bedrock-install.sh
RUN chmod +x /srv/bedrock-install.sh

WORKDIR /srv/bedrock
EXPOSE 80
CMD ["/srv/bedrock-install.sh"]
