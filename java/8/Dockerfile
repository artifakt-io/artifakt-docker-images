FROM openjdk:8-jre-buster

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
