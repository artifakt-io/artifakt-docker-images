FROM drupal:9.1-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io"

COPY --chown=www-data:www-data default.settings.php /opt/settings.php

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
