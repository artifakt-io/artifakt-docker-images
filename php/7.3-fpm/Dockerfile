FROM php:7.3-fpm

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

HEALTHCHECK CMD curl --fail http://localhost || exit 1

ARG PHP_EXTENSION_LIST="apcu bcmath bz2 calendar exif gd gettext iconv intl memcache mysqli opcache pcntl pdo_mysql shmop soap sockets sodium sysvmsg sysvsem sysvshm wddx xmlrpc xsl zip"

ARG LIB_SODIUM_VERSION=1.0.18

ARG MEMCACHE_VERSION=4.0.5.2

ARG APCU_VERSION=5.1.19

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
RUN pecl install apcu-$APCU_VERSION memcache-$MEMCACHE_VERSION

# install SODIUM php extension
# see DOCS: https://doc.libsodium.org/
# hadolint ignore=DL3003,DL4006,SC2039
RUN rm -f /usr/local/etc/php/conf.d/*sodium.ini \
  && rm -f /usr/local/lib/php/extensions/*/*sodium.so \
  && apt-get remove libsodium* -y  \
  && mkdir -p /tmp/libsodium  \
  && curl -sL https://github.com/jedisct1/libsodium/archive/$LIB_SODIUM_VERSION-RELEASE.tar.gz | tar xzf - -C  /tmp/libsodium \
  && cd /tmp/libsodium/libsodium-${LIB_SODIUM_VERSION}-RELEASE/ \
  && ./configure \
  && make && make check \
  && make install  \
  && pecl install -o -f libsodium \
  && rm -rf /tmp/libsodium

ARG COMPOSER_VERSION=1.10.22
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]