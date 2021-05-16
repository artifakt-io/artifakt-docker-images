FROM registry.artifakt.io/php:7.4-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

HEALTHCHECK CMD curl --fail http://localhost/index.php || exit 1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER www-data
RUN composer create-project symfony/website-skeleton:"^5.2" /tmp/website-skeleton && \
    rm -rf /var/www/html/{.[!.],}* && \
    mv /tmp/website-skeleton/{.[!.],}* /var/www/html
WORKDIR /var/www/html
RUN composer require symfony/apache-pack

# hadolint ignore=DL3002
USER root

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
