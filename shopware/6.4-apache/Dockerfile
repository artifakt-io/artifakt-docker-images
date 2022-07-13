FROM registry.artifakt.io/php:7.4-apache

ARG SHOPWARE_VERSION=6.4.3.1
ARG COMPOSER_VERSION=2.2.17

ENV TZ=Europe/Paris \
    APP_ENV=prod \
    MAILER_URL=null://localhost \
    SHOPWARE_ES_HOSTS= \
    SHOPWARE_ES_ENABLED=0 \
    SHOPWARE_ES_INDEXING_ENABLED=0 \
    SHOPWARE_ES_INDEX_PREFIX= \
    COMPOSER_HOME=/tmp/composer \
    SHOPWARE_HTTP_CACHE_ENABLED=1 \
    SHOPWARE_HTTP_DEFAULT_TTL=7200 \
    BLUE_GREEN_DEPLOYMENT=1 \
    INSTALL_LOCALE=en-US \
    INSTALL_CURRENCY=EUR \
    INSTALL_ADMIN_USERNAME=admin \
    INSTALL_ADMIN_PASSWORD=shopware \
    CACHE_ADAPTER=default \
    REDIS_CACHE_HOST=redis \
    REDIS_CACHE_PORT=6379 \
    REDIS_CACHE_DATABASE=0 \
    SESSION_ADAPTER=default \
    REDIS_SESSION_HOST=redis \
    REDIS_SESSION_PORT=6379 \
    REDIS_SESSION_DATABASE=1 \
    FPM_PM=dynamic \
    FPM_PM_MAX_CHILDREN=5 \
    FPM_PM_START_SERVERS=2 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=3 \
    PHP_MAX_UPLOAD_SIZE=128m \
    PHP_MAX_EXECUTION_TIME=300 \
    PHP_MEMORY_LIMIT=512m

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs default-mysql-client cron netcat && \
    rm -rf /var/lib/apt/lists/*

ENV PHP_CONF_MEMORY_LIMIT="-1"
ENV PHP_CONF_DATE_TIMEZONE="UTC"
ENV PHP_CONF_MAX_EXECUTION_TIME=600
ENV PHP_CONF_OPCACHE_VALIDATE_TIMESTAMP=1

RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY --chown=www-data composer.* /var/www/html/

USER www-data
RUN ls -la /var/www/html
RUN [ -f composer.lock ] && composer install --no-scripts --no-cache --optimize-autoloader --no-interaction --no-ansi --no-dev || true
USER root

COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2ensite 000-default

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

HEALTHCHECK CMD curl --fail http://localhost || exit 1
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
