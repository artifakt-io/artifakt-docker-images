FROM registry.artifakt.io/php:7.4-apache

# hadolint ignore=DL3022
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^5.2" .

RUN composer require symfony/apache-pack

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data .

HEALTHCHECK CMD curl --fail http://localhost/index.php || exit 1

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME var/cache
VOLUME var/logs
VOLUME var/uploads

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

ONBUILD COPY --chown=www-data:www-data . /var/www/html/
# hadolint ignore=DL3022
ONBUILD ENV APP_DEBUG=0
ONBUILD ENV APP_ENV=prod
ONBUILD RUN env && composer install --no-cache --optimize-autoloader --no-interaction --no-ansi --no-dev

# add your custom build in build.sh or install.sh
ONBUILD RUN  if [ -f artifakt/build.sh ]; then artifakt/build.sh; fi
ONBUILD RUN  if [ -f artifakt/install.sh ]; then artifakt/install.sh; fi

# copy the artifakt folder on root
ONBUILD RUN  if [ -d artifakt ]; then cp -rp artifakt /.artifakt; fi
ONBUILD RUN php bin/console cache:clear --no-warmup
ONBUILD RUN php bin/console cache:warmup
ONBUILD RUN rm -rf .git assets /root/.composer /tmp/* && chown -R www-data:www-data /var/www/html/vendor