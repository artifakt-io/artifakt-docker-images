FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# hadolint ignore=DL3022
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^5.2" .

RUN composer require symfony/apache-pack

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data .