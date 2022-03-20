FROM php:8.0-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

ARG PHP_EXTENSION_LIST="apcu bcmath bz2 calendar exif gd gettext iconv intl memcache mysqli opcache pcntl pdo_mysql shmop soap sockets sodium sysvmsg sysvsem sysvshm xmlrpc xsl zip"
ARG APACHE_MODULE_LIST="access_compat actions alias allowmethods auth_basic auth_digest authn_anon authn_core authn_dbd authn_dbm authn_file authn_socache authz_core authz_dbd authz_dbm authz_groupfile authz_host authz_owner authz_user autoindex cache cache_disk cache_socache cgi data dav dav_fs dav_lock dbd deflate dir dump_io echo env expires ext_filter filter headers http2 include info lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic lbmethod_heartbeat lua macro mime mime_magic negotiation php proxy proxy_ajp proxy_balancer proxy_connect proxy_express proxy_fcgi proxy_fdpass proxy_ftp proxy_hcheck proxy_http proxy_scgi proxy_uwsgi proxy_wstunnel remoteip reqtimeout request rewrite setenvif slotmem_plain slotmem_shm socache_dbm socache_memcache socache_shmcb ssl status substitute suexec userdir vhost_alias"

ARG APCU_VERSION=5.1.20
ARG COMPOSER_VERSION=2.3.0-RC2
ARG LIBSODIUM_PECL_VERSION=2.0.23
ARG LIBSODIUM_SYSTEM_VERSION=1.0.18-RELEASE
ARG MEMCACHE_VERSION=8.0
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
  && curl -sL https://github.com/jedisct1/libsodium/archive/${LIBSODIUM_SYSTEM_VERSION}.tar.gz | tar xzf - -C  /tmp/libsodium \
  && cd /tmp/libsodium/libsodium-${LIBSODIUM_SYSTEM_VERSION}/ \
  && ./configure \
  && make && make check \
  && make install  \
  && pecl install -o -f libsodium-$LIBSODIUM_PECL_VERSION \
  && rm -rf /tmp/libsodium

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

# finally, make sure all mods and extensions are enabled
RUN docker-php-ext-enable $PHP_EXTENSION_LIST
RUN a2enmod $APACHE_MODULE_LIST

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY zzz-artifakt.ini $PHP_INI_DIR/conf.d/zzz-artifakt.ini

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

HEALTHCHECK CMD curl --fail http://localhost || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
