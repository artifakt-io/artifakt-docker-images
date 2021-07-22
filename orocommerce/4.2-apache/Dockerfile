FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
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

ENV PHP_CONF_MEMORY_LIMIT="-1"
ENV PHP_CONF_DATE_TIMEZONE="UTC"
ENV PHP_CONF_MAX_EXECUTION_TIME=600
ENV PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=1

WORKDIR /var/www/html

RUN COMPOSER_MEMORY_LIMIT=-1 composer create-project --no-cache --no-interaction --no-ansi --no-dev oro/commerce-crm-application . 4.2.5 && \
    chown -R www-data:www-data .

RUN mkdir -p /var/www/.yarn && \
    touch /var/www/.yarnrc && \
    touch /var/www/.babel.json && \
    chown -R www-data:www-data /var/www/.yarnrc /var/www/.yarn /var/www/.babel.json

USER www-data

#RUN yarn install --cache-folder=/tmp --frozen-lockfile && yarn build && yarn cache clean

# hadolint ignore=DL3002
USER root

COPY wait-for docker-entrypoint.sh /usr/local/bin/

COPY php.ini /usr/local/etc/php/conf.d/zzzz-orocommerce.ini
COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2ensite 000-default

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]