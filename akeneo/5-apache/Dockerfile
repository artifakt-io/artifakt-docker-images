FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# see https://docs.akeneo.com/5.0/install_pim/manual/system_requirements/system_requirements.html, already enabled: curl, mbstring, xml
ARG PHP_EXTENSION_LIST="apcu bcmath exif gd imagick intl memcached mysqli opcache pdo_mysql zip"

# see release archives https://github.com/akeneo/pim-community-standard/tags
ARG AKENEO_VERSION=v6.0.64
ARG IMAGICK_VERSION=3.5.0
ARG MEMCACHED_VERSION=3.1.5
ARG COMPOSER_VERSION=2.1.3

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008,DL4006
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
        gnupg \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y yarn ghostscript aspell \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  libbz2-dev \
  libc-client-dev \
  libfreetype6-dev \
  libgmp-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libkrb5-dev \
  libldap2-dev \
  libmemcached-dev \
  libpng-dev \
  libpspell-dev \
  libtidy-dev \
  libwebp-dev \
  libxpm-dev \
  libxslt1-dev \
  libzip-dev \
  netcat \
  wget \
  zip \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# a couple of extensions are only available through PECL
RUN pecl install \
      imagick-$IMAGICK_VERSION \
      memcached-$MEMCACHED_VERSION \
    && docker-php-ext-enable imagick memcached

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype --with-jpeg --with-xpm --with-webp

# Configure the opcache library
RUN docker-php-ext-configure \
  opcache --enable-opcache

# Configure the zip library
RUN docker-php-ext-configure zip

# Install required PHP extensions
# hadolint ignore=SC2046
RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  iconv \
  intl \
  mysqli \
  opcache \
  pcntl \
  pdo_mysql \
  shmop \
  soap \
  sockets \
  sysvmsg \
  sysvsem \
  sysvshm \
  xmlrpc \
  xsl \
  zip

# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST

ENV PHP_CONF_MEMORY_LIMIT="-1"
ENV PHP_CONF_DATE_TIMEZONE="UTC"
ENV PHP_CONF_MAX_EXECUTION_TIME=600
ENV PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=1

RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

RUN curl -sSLO https://github.com/akeneo/pim-community-standard/archive/$AKENEO_VERSION.tar.gz && \
    tar -xzf $AKENEO_VERSION.tar.gz -C . && \
    rm $AKENEO_VERSION.tar.gz && \
    mv pim-community-standard-${AKENEO_VERSION:1} pim-community-standard && \
    chown -R www-data:www-data .

WORKDIR /var/www/html/pim-community-standard

RUN mkdir -p /var/www/.cache/yarn && \
    touch /var/www/.yarnrc && \
    chown -R www-data:www-data /var/www/.cache /var/www/.yarnrc

USER www-data

# dependencies / vendor
RUN composer validate --no-check-all && \
  COMPOSER_MEMORY_LIMIT=-1 composer install --no-cache

ENV NO_DOCKER=true
RUN make node_modules && \
  make cache && \
  make assets && \
  make dsm && \
  make javascript-prod && \
  make css && \
  make javascript-extensions

COPY .env.local ./.env.local
COPY parameters.yml ./config/services/parameters.yml

RUN ln -s /dev/stderr /var/www/html/pim-community-standard/var/logs/error.log && \
    ln -s /dev/stdout /var/www/html/pim-community-standard/var/logs/access.log && \
    ln -s /dev/stdout /var/www/html/pim-community-standard/var/logs/dev.log

# hadolint ignore=DL3002
USER root

COPY wait-for docker-entrypoint.sh /usr/local/bin/
COPY akeneo.conf /etc/apache2/sites-available/000-default.conf
COPY akeneo.ini /usr/local/etc/php/conf.d/zzzz-akeneo.ini

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
