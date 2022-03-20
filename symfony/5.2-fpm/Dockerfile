FROM registry.artifakt.io/php:7.4-fpm

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG COMPOSER_VERSION=2.3.0-RC2
RUN curl -sS https://getcomposer.org/installer | \
  php -- --version=${COMPOSER_VERSION} --install-dir=/usr/local/bin --filename=composer

USER www-data
RUN composer create-project symfony/website-skeleton:"^5.2" /tmp/website-skeleton && \
    rm -rf /var/www/html/{.[!.],}* && \
    mv /tmp/website-skeleton/{.[!.],}* /var/www/html

WORKDIR /var/www/html

# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD [ "php-fpm" ]