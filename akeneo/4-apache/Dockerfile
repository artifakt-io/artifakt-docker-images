FROM registry.artifakt.io/php:7.3-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# see release archives https://github.com/akeneo/pim-community-dev/releases
ARG AKENEO_VERSION=4.0.113

# see https://docs.akeneo.com/4.0/install_pim/manual/system_requirements/system_requirements.html
ARG PHP_EXTENSION_LIST="apcu bcmath gd intl mysqli pdo_mysql zip exif imagick"

ARG IMAGICK_VERSION=3.4.4
ARG MEMCACHED_VERSION=3.1.5

# hadolint ignore=DL3008,DL4006
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update && apt-get install -y --no-install-recommends \
        libmagickwand-dev \
        gnupg \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y nodejs yarn ghostscript aspell \
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
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-xpm-dir --with-webp-dir

# Configure the opcache library
RUN docker-php-ext-configure \
  opcache --enable-opcache

# Configure the zip library
RUN docker-php-ext-configure zip --with-libzip

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
  wddx \
  xmlrpc \
  xsl \
  zip

# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST

ENV PHP_CONF_MEMORY_LIMIT="-1"
ENV PHP_CONF_DATE_TIMEZONE="UTC"
ENV PHP_CONF_MAX_EXECUTION_TIME=600
ENV PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=1

ARG COMPOSER_VERSION=1.10.22
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

RUN curl -sSLO https://github.com/akeneo/pim-community-standard/archive/v$AKENEO_VERSION.tar.gz && \
    tar -xzf v$AKENEO_VERSION.tar.gz -C . && \
    rm v$AKENEO_VERSION.tar.gz && \
    mv pim-community-standard-$AKENEO_VERSION pim-community-standard && \
    chown -R www-data:www-data .

WORKDIR /var/www/html/pim-community-standard

USER www-data

RUN composer validate --no-cache --no-check-all && COMPOSER_MEMORY_LIMIT=-1 composer install
RUN yarn install --cache-folder=/tmp --frozen-lockfile && yarn cache clean
RUN APP_ENV=prod php bin/console cache:warmup
RUN rm -rf public/bundles public/js && php bin/console --env=prod pim:installer:assets --symlink --clean

# css
RUN rm -rf public/css && yarn run less

# javascript-prod
RUN rm -rf public/dist && yarn run webpack

COPY .env.local ./.env.local
COPY parameters.yml ./config/services/parameters.yml

RUN ln -s /dev/stderr /var/www/html/pim-community-standard/var/logs/error.log && \
    ln -s /dev/stdout /var/www/html/pim-community-standard/var/logs/access.log && \
    ln -s /dev/stdout /var/www/html/pim-community-standard/var/logs/dev.log

# hadolint ignore=DL3002
USER root

COPY wait-for-it.sh docker-entrypoint.sh /usr/local/bin/
COPY akeneo.conf /etc/apache2/sites-available/000-default.conf
COPY akeneo.ini /usr/local/etc/php/conf.d/zzzz-akeneo.ini

ENV APP_DATABASE_HOST=${ARTIFAKT_MYSQL_HOST:-mysql}
ENV APP_DATABASE_NAME=${ARTIFAKT_MYSQL_DATABASE_NAME:-dbname}
ENV APP_DATABASE_USER=${ARTIFAKT_MYSQL_USER:-dbuser}
ENV APP_DATABASE_PASSWORD=${ARTIFAKT_MYSQL_PASSWORD:-dbpass}

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
