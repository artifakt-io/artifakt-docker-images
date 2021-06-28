FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG COMPOSER_VERSION=1.10.22
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /var/log/artifakt && chown -R www-data:www-data /var/log/artifakt

USER www-data
RUN composer --no-cache create-project symfony/website-skeleton:"^4.4" /tmp/website-skeleton && \
    rm -rf /var/www/html/{.[!.],}* && \
    mv /tmp/website-skeleton/{.[!.],}* /var/www/html
WORKDIR /var/www/html
RUN composer require symfony/apache-pack

# hadolint ignore=DL3002
USER root

COPY 000-default.conf /etc/apache2/sites-available/
RUN a2enmod rewrite && a2ensite 000-default

# Create the parameter.yml file if it doesn't exist
COPY --chown=www-data:www-data etc/parameters.yml /var/www/html/config/parameters.yml

HEALTHCHECK CMD curl --fail http://localhost/index.php || exit 1

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
