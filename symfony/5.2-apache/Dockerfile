FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

# hadolint ignore=DL3022
COPY --from=composer /usr/bin/composer /usr/bin/composer

# reset html folder content
#WORKDIR /var/www/
#RUN rm -rf /var/www/html && mkdir -p /var/www/html
#WORKDIR /var/www/html

USER www-data
RUN ls -laR /var/www/html
RUN composer create-project symfony/website-skeleton:"^5.2" .
RUN composer require symfony/apache-pack

# hadolint ignore=DL3002
USER root

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
