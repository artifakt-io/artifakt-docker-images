FROM php:7.2-apache

# see release archives https://github.com/akeneo/pim-community-dev/releases
ARG AKENEO_VERSION=3.2.80

# see https://docs.akeneo.com/3.2/install_pim/manual/system_requirements/system_requirements.html
# NB: already enabled: xml, curl
ARG PHP_EXTENSION_LIST="apcu bcmath gd intl mysqli pdo_mysql zip exif imagick"

ARG APCU_VERSION=5.1.19
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
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-xpm-dir --with-webp-dir

# Configure the opcache library
RUN docker-php-ext-configure \
  opcache --enable-opcache

# Configure the zip library
RUN docker-php-ext-configure \
  zip --with-libzip

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

# a couple of extensions are only available through PECL
RUN pecl install apcu-$APCU_VERSION

# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST

# hadolint ignore=DL3022
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN curl -sSLO https://github.com/akeneo/pim-community-dev/archive/v$AKENEO_VERSION.tar.gz && \
    tar -xzf v$AKENEO_VERSION.tar.gz -C . && \
    rm v$AKENEO_VERSION.tar.gz && \
    mv pim-community-dev-$AKENEO_VERSION pim-community-standard && \
    chown -R www-data:www-data .

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -ri -e 's!memory_limit = 128M!memory_limit = 512M!g' /usr/local/etc/php/php.ini

RUN a2enmod rewrite

COPY akeneo.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html/pim-community-standard

USER www-data

RUN composer update --no-cache --no-dev --optimize-autoloader --prefer-dist --no-interaction && \
    yarn install --cache-folder=/tmp && \
    php bin/console pim:installer:assets --symlink --clean --env=prod && \
    php bin/console cache:clear --no-warmup --env=prod && \
    yarn run webpack

COPY parameters.yml ./app/config/parameters.yml

# hadolint ignore=DL3002
USER root

COPY wait-for-it.sh docker-entrypoint.sh /usr/local/bin/

VOLUME var/cache
VOLUME var/logs
VOLUME var/uploads

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
