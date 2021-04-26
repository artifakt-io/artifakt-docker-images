FROM registry.artifakt.io/php:7.4-apache

# hadolint ignore=DL3022
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^4.4" .

RUN composer require symfony/apache-pack

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data .