FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# see release archives https://github.com/akeneo/pim-community-dev/releases
ARG AKENEO_VERSION=5.0.26

# see https://docs.akeneo.com/5.0/install_pim/manual/system_requirements/system_requirements.html
ARG PHP_EXTENSION_LIST="apcu bcmath gd intl mysqli pdo_mysql zip exif imagick"

ARG IMAGICK_VERSION=3.4.4

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

# Install image magick
RUN pecl install imagick-$IMAGICK_VERSION \
    && docker-php-ext-enable imagick

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

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -ri -e 's!memory_limit = 128M!memory_limit = 512M!g' /usr/local/etc/php/php.ini

ARG COMPOSER_VERSION=2.0.14
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

RUN curl -sSLO https://github.com/akeneo/pim-community-dev/archive/v$AKENEO_VERSION.tar.gz && \
    tar -xzf v$AKENEO_VERSION.tar.gz -C . && \
    rm v$AKENEO_VERSION.tar.gz && \
    mv pim-community-dev-$AKENEO_VERSION pim-community-standard && \
    chown -R www-data:www-data .

WORKDIR /var/www/html/pim-community-standard

USER www-data

# dependencies
RUN composer validate --no-check-all && \
  composer install && \
  yarn install --frozen-lockfile && \
  yarn cache clean

# cache
RUN rm -rf var/cache && php bin/console cache:warmup

# assets
RUN rm -rf public/bundles public/js && php bin/console --env=prod pim:installer:assets --symlink --clean

# css
RUN rm -rf public/css && yarn run less

# dsm
RUN yarn --cwd=akeneo-design-system install --frozen-lockfile && \
    yarn cache clean && \
    yarn --cwd=akeneo-design-system run lib:build

# javascript-prod
RUN yarn run update-extensions && \
    rm -rf public/dist && \
    yarn run webpack

COPY .env.local ./.env.local
COPY parameters.yml ./config/services/parameters.yml

# hadolint ignore=DL3002
USER root

COPY wait-for-it.sh docker-entrypoint.sh /usr/local/bin/
COPY akeneo.conf /etc/apache2/sites-available/000-default.conf
COPY akeneo.ini /usr/local/etc/php/conf.d/

VOLUME /var/www/html/pim-community-standard/var/cache
VOLUME /var/www/html/pim-community-standard/var/logs
VOLUME /var/www/html/pim-community-standard/var/uploads

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
