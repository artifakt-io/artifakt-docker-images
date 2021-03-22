FROM registry.artifakt.io/php:7.4-fpm

# hadolint ignore=DL3022
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^5.2" .

RUN chown -R www-data:www-data .

ONBUILD COPY --chown=www-data:www-data . /var/www/html/
# hadolint ignore=DL3022
ONBUILD ENV APP_DEBUG=0
ONBUILD ENV APP_ENV=prod

ONBUILD COPY Dockerfile composer.json* /var/www/html/
ONBUILD RUN  if [ -f composer.json ]; then composer install --no-cache --optimize-autoloader --no-interaction --no-ansi --no-dev; fi
ONBUILD COPY . /var/www/html
ONBUILD RUN php bin/console cache:clear --no-warmup
ONBUILD RUN php bin/console cache:warmup
ONBUILD RUN rm -rf .git assets /root/.composer /tmp/* && chown -R www-data:www-data /var/www/html/vendor
