FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3022
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

USER www-data
RUN composer create-project symfony/website-skeleton:"^5.2" /tmp/website-skeleton && \
    rm -rf /var/www/html/{.[!.],}* && \
    mv /tmp/website-skeleton/{.[!.],}* /var/www/html
WORKDIR /var/www/html
RUN composer require symfony/apache-pack

# hadolint ignore=DL3002
USER root

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf