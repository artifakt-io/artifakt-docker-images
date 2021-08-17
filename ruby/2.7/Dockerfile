FROM changeme

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
