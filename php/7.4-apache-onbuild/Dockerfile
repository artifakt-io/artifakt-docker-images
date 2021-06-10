FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

ONBUILD COPY --chown=www-data:www-data . /var/www/html/
ONBUILD WORKDIR /var/www/html
ONBUILD RUN [ -f composer.lock ] && composer install --no-cache --optimize-autoloader --no-interaction --no-ansi --no-dev || true
