FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# hadolint ignore=DL3022
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN composer create-project symfony/website-skeleton:"^5.2" .

RUN composer require symfony/apache-pack

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf

RUN chown -R www-data:www-data .

HEALTHCHECK CMD curl --fail http://localhost/index.php || exit 1

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

VOLUME /var/www/html/var/cache
VOLUME /var/www/html/var/log
VOLUME /var/www/html/var/uploads

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]

### FOLLOWING INSTRUCTIONS ARE FOR CHILD IMAGES ONLY
#ONBUILD COPY --chown=www-data:www-data composer.*  package.json /var/www/html/

# hadolint ignore=DL3022
ONBUILD COPY --chown=www-data:www-data . /var/www/html/
ONBUILD ENV APP_DEBUG=0
ONBUILD ENV APP_ENV=prod
ONBUILD RUN env && composer install --no-cache --optimize-autoloader --no-interaction --no-ansi --no-dev

# copy the artifakt folder on root
ONBUILD RUN  if [ -d .artifakt ]; then cp -rp /var/www/html/.artifakt /.artifakt/; elif [ -d artifakt ]; then cp -rp /var/www/html/artifakt /.artifakt; fi

# run custom scripts build.sh or install.sh
ONBUILD RUN  if [ -f /.artifakt/build.sh ]; then /.artifakt/build.sh; fi
ONBUILD RUN  if [ -f /.artifakt/install.sh ]; then /.artifakt/install.sh; fi

ONBUILD RUN php bin/console cache:clear --no-warmup
ONBUILD RUN php bin/console cache:warmup
ONBUILD RUN rm -rf .git assets /root/.composer /tmp/* && chown -R www-data:www-data /var/www/html/vendor
