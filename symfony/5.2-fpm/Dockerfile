FROM registry.artifakt.io/php:7.4-fpm

# hadolint ignore=DL3022
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^5.2" .

RUN chown -R www-data:www-data .