FROM debian:buster-slim

LABEL vendor="Artifakt" \
      author="djalal@artifakt.io" \
      stage="retired"

RUN echo This runtime is now retired, see https://docs.artifakt.com/

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
