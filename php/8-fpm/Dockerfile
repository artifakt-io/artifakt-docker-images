FROM php:8-fpm

LABEL vendor="Artifakt.com" \
      author="djalal@artifakt.com"

HEALTHCHECK CMD curl --fail http://localhost || exit 1

ARG PHP_EXTENSION_LIST="apcu bcmath bz2 calendar exif gd gettext iconv intl memcache mysqli opcache pcntl pdo_mysql shmop soap sockets sodium sysvmsg sysvsem sysvshm xmlrpc xsl zip"

ARG LIB_SODIUM_VERSION=1.0.18

ARG MEMCACHE_VERSION=8.0

ARG APCU_VERSION=5.1.20
ARG XMLRPC_VERSION=1.0.0RC2

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

#RUN curl -sSLO https://github.com/php/pecl-text-wddx/archive/354bfc1d1a7390c14ccc0d0c5eaf83748e40bcf8.zip && \
# tar xzf 354bfc1d1a7390c14ccc0d0c5eaf83748e40bcf8.zip && \
# cd 354bfc1d1a7390c14ccc0d0c5eaf83748e40bcf8 && \
# usr/local/bin/phpize && \
# ./configure && \
# make && \
# make install

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
#  wddx \
#  xmlrpc \
  xsl \
  zip

# a couple of extensions are only available through PECL
RUN pecl install \
    apcu-$APCU_VERSION \
    memcache-$MEMCACHE_VERSION \
    xmlrpc-$XMLRPC_VERSION

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


# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST