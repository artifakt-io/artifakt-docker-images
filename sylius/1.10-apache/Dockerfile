FROM registry.artifakt.io/php:8-apache

LABEL vendor="Artifakt" \
    author="engineering@artifakt.io" \
    stage="alpha"

ARG COMPOSER_VERSION=2.1.3
ARG SYLIUS_VERSION=v1.12.4

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install git to fix deploy issue (28/09/2022)
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008,DL4006
RUN export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    netcat \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install --no-install-recommends -y yarn \
    && rm -rf /var/lib/apt/lists/*

ENV MESSENGER_TRANSPORT_DSN="doctrine://default"
ENV PHP_CONF_MEMORY_LIMIT="-1"
ENV PHP_CONF_DATE_TIMEZONE="UTC"
ENV PHP_CONF_MAX_EXECUTION_TIME=600
ENV PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=1

RUN curl -sS https://getcomposer.org/installer | \
    php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

RUN COMPOSER_MEMORY_LIMIT=-1 composer create-project --no-scripts --no-cache --no-interaction --no-ansi sylius/sylius-standard:${SYLIUS_VERSION} . && \
    chown -R www-data:www-data .

RUN mkdir -p /var/www/.yarn && \
    touch /var/www/.yarnrc && \
    touch /var/www/.babel.json && \
    chown -R www-data:www-data /var/www/.yarnrc /var/www/.yarn /var/www/.babel.json

USER www-data

RUN yarn install --cache-folder=/tmp --frozen-lockfile && yarn build && yarn cache clean

# hadolint ignore=DL3002
USER root

COPY wait-for docker-entrypoint.sh /usr/local/bin/

COPY php.ini /usr/local/etc/php/conf.d/zzzz-sylius.ini
COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2ensite 000-default

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
