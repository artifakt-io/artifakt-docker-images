FROM drupal:9.1-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

COPY --chown=www-data:www-data default.settings.php /opt/settings.php

WORKDIR /var/www/html

ARG COMPOSER_VERSION=2.0.13
RUN curl -sS https://getcomposer.org/installer | \
php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
