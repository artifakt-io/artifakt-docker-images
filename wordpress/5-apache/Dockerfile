FROM wordpress:5-apache

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="alpha"

# hadolint ignore=SC2016
RUN echo 'SetEnv ${HTTPS}' > /etc/apache2/conf-enabled/force-ssl.conf 

# hadolint ignore=DL3045
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
