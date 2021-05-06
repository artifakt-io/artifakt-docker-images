ARG PHP_VERSION=7.4-apache

FROM php:${PHP_VERSION}

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

ARG MYSQL_HOST
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE
ARG MAGENTO_LANGUAGE
ARG MAGENTO_TIMEZONE
ARG MAGENTO_DEFAULT_CURRENCY
ARG MAGENTO_URL
ARG MAGENTO_BACKEND_FRONTNAME
ARG MAGENTO_USE_SECURE
ARG MAGENTO_BASE_URL_SECURE
ARG MAGENTO_USE_SECURE_ADMIN
ARG MAGENTO_ADMIN_FIRSTNAME
ARG MAGENTO_ADMIN_LASTNAME
ARG MAGENTO_ADMIN_EMAIL
ARG MAGENTO_ADMIN_USERNAME
ARG MAGENTO_ADMIN_PASSWORD

ENV PHP_MEMORY_LIMIT 4G
ENV MAGENTO_ROOT /app
ENV DEBUG false
ENV MAGENTO_RUN_MODE production
ENV UPLOAD_MAX_FILESIZE 64M
ENV PHP_EXTENSIONS bcmath bz2 calendar exif gd gettext intl mysqli opcache pdo_mysql redis soap sockets sysvmsg sysvsem sysvshm xsl zip pcntl

# Install dependencies
# hadolint ignore=DL3008
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  libbz2-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libfreetype6-dev \
  libgeoip-dev \
  libgmp-dev \
  libmagickwand-dev \
  libmagickcore-dev \
  libc-client-dev \
  libkrb5-dev \
  libicu-dev \
  libldap2-dev \
  libpspell-dev \
  libtidy-dev \
  libxslt1-dev \
  libyaml-dev \
  libzip-dev \
  lsof \
  sendmail \
  sendmail-bin \
  sudo \
  wget \
  zip \
  && rm -rf /var/lib/apt/lists/*

# Configure the gd library
RUN docker-php-ext-configure \
  gd --with-freetype --with-jpeg
RUN docker-php-ext-configure \
  imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-configure \
  ldap --with-libdir=lib/x86_64-linux-gnu
RUN docker-php-ext-configure \
  opcache --enable-opcache
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
  gmp \
  imap \
  intl \
  ldap \
  mysqli \
  opcache \
  pdo_mysql \
  pspell \
  shmop \
  soap \
  sockets \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xmlrpc \
  xsl \
  zip \
  pcntl

RUN pecl install -o -f \
  geoip-1.1.1 \
  igbinary \
  imagick \
  mailparse \
  msgpack \
  oauth \
  propro \
  raphf \
  redis \
  yaml

# hadolint ignore=DL3003,DL4006,SC2039
RUN rm -f /usr/local/etc/php/conf.d/*sodium.ini \
  && rm -f /usr/local/lib/php/extensions/*/*sodium.so \
  && apt-get remove libsodium* -y  \
  && mkdir -p /tmp/libsodium  \
  && curl -sL https://github.com/jedisct1/libsodium/archive/1.0.18-RELEASE.tar.gz | tar xzf - -C  /tmp/libsodium \
  && cd /tmp/libsodium/libsodium-1.0.18-RELEASE/ \
  && ./configure \
  && make && make check \
  && make install  \
  && cd / \
  && rm -rf /tmp/libsodium  \
  && pecl install -o -f libsodium

RUN docker-php-ext-enable \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  geoip \
  gettext \
  gmp \
  igbinary \
  imagick \
  imap \
  intl \
  ldap \
  mailparse \
  msgpack \
  mysqli \
  oauth \
  opcache \
  pdo_mysql \
  propro \
  pspell \
  raphf \
  redis \
  shmop \
  soap \
  sockets \
  sodium \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xmlrpc \
  xsl \
  yaml \
  zip \
  pcntl

# hadolint ignore=DL3022
COPY --from=composer:1.10 /usr/bin/composer /usr/bin/composer

# hadolint ignore=DL3022
COPY --from=mysql:8 /usr/bin/my* /usr/bin/

COPY etc/magento.ini /usr/local/etc/php/conf.d/magento.ini
COPY etc/mail.ini /usr/local/etc/php/conf.d/zz-mail.ini
COPY etc/crontab /etc/cron.d/magento2-cron
COPY etc/000-default.conf /usr/apache2/sites-available/000-default.conf
RUN a2enmod rewrite && a2ensite 000-default

HEALTHCHECK CMD curl --fail http://localhost/index.php || exit 1

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

### FOLLOWING INSTRUCTIONS ARE FOR CHILD IMAGES ONLY
# hadolint ignore=DL3022
ONBUILD COPY --chown=www-data:www-data . /var/www/html/

ONBUILD COPY .artifakt /var/www/html/.artifakt
ONBUILD RUN ls -la /var/www/html/.artifakt

# copy the artifakt folder on root
ONBUILD RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; elif [ -d artifakt ]; then cp -rp /var/www/html/artifakt /.artifakt; fi

# run custom scripts build.sh or install.sh
ONBUILD RUN  if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi
ONBUILD RUN  if [ -f /.artifakt/install.sh ]; then /.artifakt/install.sh; fi